import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { logger: ['error','warn','log'] });
  app.enableCors({ origin: ['http://localhost:5173', 'tauri://localhost', 'file://'] });
  const port = process.env.PORT ? +process.env.PORT : 4000;
  await app.listen(port, '127.0.0.1');
  console.log(`Backend listo en http://127.0.0.1:${port}`);
}
bootstrap();
