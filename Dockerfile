FROM python:3.12-slim

# Create a non-root user and group
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Define working directory
WORKDIR /app

# Change ownership of the working directory to the non-root user
RUN chown appuser:appuser /app

# Switch to the non-root user
USER appuser

# Copia os arquivos de requirements e instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante da aplicação
COPY . .

# Expõe a porta padrão do Uvicorn
EXPOSE 8000

# Comando para rodar a aplicação
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# Define the health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:5000/health || exit 1