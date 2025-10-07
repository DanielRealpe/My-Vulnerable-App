FROM python:3.12-slim

# Copia os arquivos de requirements e instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create a non-root user and group
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Define working directory
WORKDIR /app

# Change ownership of the working directory to the non-root user
RUN chown appuser:appuser /app

# Switch to the non-root user
USER appuser


# Copia o restante da aplicação
COPY . .

# Expõe a porta padrão do Uvicorn
EXPOSE 12345

# Comando para rodar a aplicação
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "12345"]

# Define the health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:12345/health || exit 1