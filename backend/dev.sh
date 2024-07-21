PORT="${PORT:-8080}"
python3 -m uvicorn main:app --port $PORT --host 0.0.0.0 --forwarded-allow-ips '*' --reload