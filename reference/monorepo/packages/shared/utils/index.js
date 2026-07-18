// @taskboard/utils — framework-agnostic helpers shared by all packages.
export function formatDate(iso) {
  return new Date(iso).toISOString().slice(0, 10);
}

export function classNames(...arr) {
  return arr.filter(Boolean).join(' ');
}