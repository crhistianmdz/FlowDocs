// packages/mobile/lib/login.ts — RN login; no docs/tasks HU yet (mobile parity follows web).
import type { AuthResponse } from '@taskboard/types';

const API_BASE = process.env.EXPO_PUBLIC_API_BASE ?? 'http://localhost:3000';

export async function loginRN(email: string, password: string): Promise<AuthResponse> {
  const res = await fetch(`${API_BASE}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
    credentials: 'include',
  });
  if (!res.ok) throw new Error('login failed');
  return res.json() as Promise<AuthResponse>;
}