import { defineConfig } from 'vite';
import ViteRails from 'vite-plugin-rails';

export default defineConfig({
  plugins: [
    ViteRails({
      fullReload: {
        additionalPaths: ['app/frontend/**/*', 'app/components/**/*'],
      },
    }),
  ],
});
