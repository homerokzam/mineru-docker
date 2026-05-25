FROM vllm/vllm-openai:v0.11.2

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        fontconfig \
        fonts-noto-cjk \
        fonts-noto-core \
        libgl1 && \
    fc-cache -fv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements-mineru.txt /app/requirements-mineru.txt

RUN python3 -m pip install -r /app/requirements-mineru.txt --break-system-packages && \
    python3 -m pip cache purge

ENV MINERU_MODEL_SOURCE=local
ENV MINERU_API_OUTPUT_ROOT=/data-mineru/output
ENV HF_HOME=/data-mineru/huggingface
ENV TRANSFORMERS_CACHE=/data-mineru/huggingface

RUN mkdir -p /data-mineru/output /data-mineru/huggingface

RUN mineru-models-download -s huggingface -m all

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=5 \
    CMD curl -f http://localhost:8000/health || exit 1

ENTRYPOINT ["mineru-api"]
CMD ["--host", "0.0.0.0", "--port", "8000"]
