# Stage 1: Build the React app
FROM node:18.0.0-alpine3.15 as build

WORKDIR /app

# Only copy package.json and package-lock.json to leverage Docker layer caching
COPY package.json package-lock.json ./

# Install only production dependencies
RUN npm install --production

# Copy all source code
COPY . .

# Build the app
RUN npm run build

# Stage 2: Nginx setup to serve the build
FROM nginx:1.21.3-alpine

# Copy the build output from the 'build' stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
