// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Viem from "viem";
import * as S$RescriptSchema from "rescript-schema/src/S.res.mjs";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

function fromString(str) {
  var addr;
  try {
    addr = Viem.getAddress(str);
  }
  catch (raw_exn){
    var exn = Caml_js_exceptions.internalToOCamlException(raw_exn);
    return {
            TAG: "Error",
            _0: exn
          };
  }
  return {
          TAG: "Ok",
          _0: addr
        };
}

function toString(addr) {
  return addr;
}

var schema = S$RescriptSchema.transform(S$RescriptSchema.string, (function (s) {
        return {
                p: (function (str) {
                    var addr = fromString(str);
                    if (addr.TAG === "Ok") {
                      return addr._0;
                    } else {
                      return s.fail("Invalid address", undefined);
                    }
                  }),
                s: toString
              };
      }));

var Address = {
  fromString: fromString,
  toString: toString,
  schema: schema
};

function fromString$1(str) {
  return str;
}

function toString$1(addr) {
  return addr;
}

var Topic = {
  fromString: fromString$1,
  toString: toString$1,
  schema: S$RescriptSchema.string
};

export {
  Address ,
  Topic ,
}
/* schema Not a pure module */
