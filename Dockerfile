FROM ruby:3.2.2

# Instalar dependencias del sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs

# Crear directorio de la aplicación
WORKDIR /app

# Instalar bundler
RUN gem install bundler:2.4.22

# Copiar Gemfile y Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar gemas
RUN bundle install

# Copiar el resto de la aplicación
COPY . .

# Agregar scripts de inicio
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Exponer puerto
EXPOSE 3000