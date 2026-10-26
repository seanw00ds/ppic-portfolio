# ---- Stage 1: the "kitchen". Install and build everything here ----
FROM node:22-slim AS build
WORKDIR /app

# Copy ONLY the package list first, then install.
# Docker remembers this step, so editing a page later doesn't reinstall every package.
COPY package.json package-lock.json ./
RUN npm ci

# Now copy the rest of the code and build the site
COPY . .
RUN npm run build

# ---- Stage 2: the "plate". Only what's needed to run the site ----
FROM node:22-slim
WORKDIR /app
ENV NODE_ENV=production

# Take just the finished site out of the kitchen, leave the mess behind
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
COPY --from=build /app/public ./public

EXPOSE 3000
CMD ["node", "server.js"]
