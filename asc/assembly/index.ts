// The entry file of your WebAssembly module.
@external("env", "getThreadsCount")
declare function getThreadsCount(): i32;

export function run(): i32 {
  return getThreadsCount();
}

