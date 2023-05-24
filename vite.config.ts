import { defineConfig } from "vite";
import ViteRails from "vite-plugin-rails";

export default defineConfig({
  plugins: [
    ViteRails({
      envVars: { RAILS_ENV: "development" },
      fullReload: {
        additionalPaths: [],
      },
    }),
   ],
});
