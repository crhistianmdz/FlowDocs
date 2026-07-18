// @taskboard/ui — shared React components used by web & mobile (RN Web).
export function Button({ label, onClick }) {
  return (
    <button type="button" onClick={onClick} className="tb-button">
      {label}
    </button>
  );
}