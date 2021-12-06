# Get NPM packages
FROM node:14-alpine AS dependencies 
WORKDIR /app
COPY csci2690-assn2/package.json csci2690-assn2/package-lock.json ./
RUN npm ci

# Rebuild the source code only when needed
FROM node:14-alpine AS builder
WORKDIR /app
COPY . .
COPY --from=dependencies /csci2690-assn2/node_modules ./node_modules 
RUN npm run build

# Production image, copy all the files and run next
FROM node:14-alpine AS runner 
WORKDIR /csci2690-assn2
COPY --from=builder /csci2690-assn2/.next ./.next
COPY --from=builder /csci2690-assn2/node_modules ./node_modules
COPY --from=builder /csci2690-assn2/package.json ./package.json 
EXPOSE 3000
CMD ["npm", "start"]
