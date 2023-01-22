{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# runtime
, editables
, importlib-metadata # < 3.8
, packaging
, pathspec
, pluggy
, tomli

# tests
, build
, python
, requests
, virtualenv
}:

let
  pname = "hatchling";
  version = "1.11.1";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n4Q2H3DPOnq5VDsMPsxkIR7SuopganHrakc8HJsI4dA=";
  };

  # listed in backend/src/hatchling/ouroboros.py
  propagatedBuildInputs = [
    editables
    packaging
    pathspec
    pluggy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [
    "hatchling"
    "hatchling.build"
  ];

  # tries to fetch packages from the internet
  doCheck = false;

  # listed in /backend/tests/downstream/requirements.txt
  nativeCheckInputs = [
    build
    packaging
    requests
    virtualenv
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/downstream/integrate.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Modern, extensible Python build backend";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/blob/hatchling-v${version}/docs/history.md#hatchling";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ofek ];
  };
}
