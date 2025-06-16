from sentence_transformers import SentenceTransformer
import faiss
import numpy as np
import json

model = SentenceTransformer("jhgan/ko-sroberta-multitask")  # Ko-SBERT

texts = []
with open("gyeongsang.jsonl", "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        item = json.loads(line)
        user_messages = [m["content"] for m in item["messages"] if m["role"] == "user"]
        if user_messages:
            texts.append(user_messages[0])

embeddings = model.encode(texts, convert_to_numpy=True)

dimension = embeddings.shape[1]
index = faiss.IndexFlatL2(dimension)
index.add(embeddings)

faiss.write_index(index, "gyeongsang_dialect.index")
np.save("gyeongsang_texts.npy", np.array(texts))

