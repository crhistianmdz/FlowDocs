// src/services/auth.service.ts
// Stub — see HU-001-login.md for full scope.
export type LoginInput = { email: string; password: string };

export async function loginService(_input: LoginInput): Promise<{ accessToken: string }> {
  // TODO: validate, lookup user, verify bcrypt, issue tokens.
  throw new Error('not implemented');
}