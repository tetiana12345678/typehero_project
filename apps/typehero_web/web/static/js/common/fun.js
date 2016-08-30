// reusable auxiliary functions
export const keys = o => Reflect.ownKeys(o);
export const assign = (...o) => Object.assign({}, ...o);
export const map = f => xs => xs.map(x => f(x));

export const omap = f => o => {
  o = assign(o); // A
  map(x => o[x] = f(o[x])) (keys(o)); // B
  return o;
};
