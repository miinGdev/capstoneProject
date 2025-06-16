from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import openai
import faiss
import numpy as np
from sentence_transformers import SentenceTransformer

openai.api_key = "MY_API_KEY"

# FastAPI 앱 만들기
app = FastAPI()

# CORS 설정 (Flutter 앱 주소 넣어줘, 테스트 중이면 '*' 써도 됨)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 실서비스면 Flutter 앱 도메인만 넣어야 함
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 모델 & 벡터 로딩 (처음 1회만)
model = SentenceTransformer("jhgan/ko-sroberta-multitask")
index = faiss.read_index("merged_index")
texts = np.load("merged_texts.npy", allow_pickle=True)

# Flutter에서 받을 요청 구조 정의
class QueryRequest(BaseModel):
    query: str

# 스타일 감지 함수 (밈/사투리 확인)
def check_meme_style(user_message: str, context: str):
    prompt = f"다음 문장에서 유머러스하거나 밈 스타일이면 'meme', 사투리면 'dialect', 아니면 'normal'이라고 대답해.\n\n문장: {user_message}\n\n문맥: {context}"
    
    response = openai.Completion.create(
        model="gpt-4o-2024-08-06",  # 훈련된 모델 사용 or 다른 모델?
        prompt=prompt,
        max_tokens=5,
        temperature=0.3,
    )
    
    return response.choices[0].text.strip().lower()

# 라우트 정의
@app.post("/rag")
async def rag_response(request: QueryRequest):
    query = request.query

    # 벡터화 (쿼리)
    query_vector = model.encode(query, convert_to_numpy=True).astype("float32")

    # FAISS에서 검색 (가장 유사한 3개 텍스트 찾기)
    D, I = index.search(np.array([query_vector]), k=3)
    
    # 검색된 텍스트 가져오기
    retrieved_texts = [texts[i] for i in I[0]]
    context = "\n".join(retrieved_texts)

    # 밈/사투리 스타일 확인
    style = check_meme_style(query, context)

    # RAG 응답 생성
    prompt = f"다음 내용을 참고해서 답해줘:\n\n{context}\n\n질문: {query}"
    
    # GPT 모델에 메시지 전달 (밈/사투리 아닌 경우에 요청사항 추가)
    if style == "normal":
        response = openai.Completion.create(
            model="ft:gpt-4o-2024-08-06:team::Bg7G2QnF",  # 훈련된 모델 사용
            prompt=f"사용자가 요청하는 대로 말투와 대답 형식을 맞춰줘. 다음은 사용자 질문입니다: {query}",
            max_tokens=150
        )
    else:
        # 스타일 감지된 경우, RAG 문맥 + GPT 응답 생성
        rag_prompt = f"사용자 질문: {query}\n스타일 문맥:\n{context}\n최종 응답:"
        response = openai.Completion.create(
            model="ft:gpt-4o-2024-08-06:team::Bg7G2QnF",  # 훈련된 모델 사용
            prompt=rag_prompt,
            max_tokens=150
        )

    # 응답 반환
    return {
        "related_texts": retrieved_texts,
        "response": response.choices[0].text.strip(),
        "style": style  # 밈/사투리 스타일 포함
    }
