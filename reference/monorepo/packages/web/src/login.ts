// packages/web/src/login.ts — calls api; see packages/web/docs/tasks/HU-001-login.md
import type { AuthResponse, User } from '@taskboard/types';

export async function login(email: string, password: string): Promise<AuthResponse> {
  const res = await fetch('/api/auth/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
    credentials: 'include',
  });
  if (!res.ok) throw new Error('login failed');
  return res.json() as Promise<AuthResponse>;
}