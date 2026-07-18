// src/hooks/useAuth.ts
// Stub — see HU-001-login.md for full scope.
import { useState } from 'react';

export function useAuth() {
  const [accessToken, setAccessToken] = useState<string | null>(null);
  return { accessToken, setAccessToken };
}