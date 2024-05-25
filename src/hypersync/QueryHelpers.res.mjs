// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Promise from "@rescript/core/src/Core__Promise.res.mjs";
import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";
import * as S$RescriptSchema from "rescript-schema/src/S.res.mjs";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

var FailedToFetch = /* @__PURE__ */Caml_exceptions.create("QueryHelpers.FailedToFetch");

var FailedToParseJson = /* @__PURE__ */Caml_exceptions.create("QueryHelpers.FailedToParseJson");

async function executeFetchRequest(endpoint, method, bodyAndSchema, responseSchema, param) {
  try {
    var body = Belt_Option.map(bodyAndSchema, (function (param) {
            var jsonString = S$RescriptSchema.serializeToJsonStringWith(param[0], param[1], undefined);
            if (jsonString.TAG === "Ok") {
              return jsonString._0;
            } else {
              return S$RescriptSchema.$$Error.raise(jsonString._0);
            }
          }));
    var res = await Core__Promise.$$catch(fetch(endpoint, {
              method: method,
              body: body,
              headers: Caml_option.some(new Headers({
                        "Content-type": "application/json"
                      }))
            }), (function (e) {
            return Promise.reject({
                        RE_EXN_ID: FailedToFetch,
                        _1: e
                      });
          }));
    var data = await Core__Promise.$$catch(res.json(), (function (e) {
            return Promise.reject({
                        RE_EXN_ID: FailedToParseJson,
                        _1: e
                      });
          }));
    var ok = S$RescriptSchema.parseWith(data, responseSchema);
    if (ok.TAG === "Ok") {
      return ok;
    } else {
      return {
              TAG: "Error",
              _0: {
                TAG: "Deserialize",
                _0: data,
                _1: ok._0
              }
            };
    }
  }
  catch (raw_exn){
    var exn = Caml_js_exceptions.internalToOCamlException(raw_exn);
    if (exn.RE_EXN_ID === FailedToFetch) {
      return {
              TAG: "Error",
              _0: {
                TAG: "FailedToFetch",
                _0: exn._1
              }
            };
    } else if (exn.RE_EXN_ID === FailedToParseJson) {
      return {
              TAG: "Error",
              _0: {
                TAG: "FailedToParseJson",
                _0: exn._1
              }
            };
    } else {
      return {
              TAG: "Error",
              _0: {
                TAG: "Other",
                _0: exn
              }
            };
    }
  }
}

export {
  FailedToFetch ,
  FailedToParseJson ,
  executeFetchRequest ,
}
/* S-RescriptSchema Not a pure module */
