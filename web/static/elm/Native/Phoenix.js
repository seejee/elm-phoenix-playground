Elm.Native.Phoenix = {};
Elm.Native.Phoenix.make = function(localRuntime) {
  localRuntime.Native         = localRuntime.Native || {};
  localRuntime.Native.Phoenix = localRuntime.Native.Phoenix || {};

  if (localRuntime.Native.Phoenix.values) {
    return localRuntime.Native.Phoenix.values;
  }

  return localRuntime.Native.Phoenix.values = {
    foo: function() { return 7; }
  };
};
