// packages/api/src/auth.ts — login handler; see packages/api/docs/tasks/HU-001-login.md
import type { User } from '@taskboard/types';
import jwt from 'jsonwebtoken';

const SECRET = process.env.JWT_SECRET ?? 'dev-secret';

export async function loginHandler(body: { email: string; password: string }): Promise<{
  accessToken: string;
  user: User;
}> {
  // TODO: lookup, verify bcrypt
  const user: User = { id: 'stub', email: body.email, role: 'user', companyId: 1 };
  const accessToken = jwt.sign({ sub: user.id, role: user.role }, SECRET, { expiresIn: '15m' });
  return { accessToken, user };
}