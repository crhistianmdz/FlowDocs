// @taskboard/types — shared contracts across web/mobile/api.

export type Role = 'admin' | 'user';

export interface User {
  id: string;
  email: string;
  role: Role;
  companyId: number;
}

export interface AuthResponse {
  accessToken: string;
  user: User;
}

export interface ApiError {
  code: 'VALIDATION_ERROR' | 'UNAUTHORIZED' | 'NOT_FOUND' | 'INTERNAL_ERROR';
  message: string;
}