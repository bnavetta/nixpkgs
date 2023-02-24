{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flask
, flask-silk
, future
, pathlib
}:

buildPythonPackage rec {
  pname = "flask-autoindex";
  version = "0.6.6";

  src = fetchPypi {
    pname = "Flask-AutoIndex";
    inherit version;
    sha256 = "ea319f7ccadf68ddf98d940002066278c779323644f9944b300066d50e2effc7";
  };

  propagatedBuildInputs = [
    flask
    flask-silk
    future
  ] ++ lib.optionals (pythonOlder "3.4") [
    pathlib
  ];

  pythonImportsCheck = [
    "flask_autoindex"
  ];

  meta = with lib; {
    description = "The mod_autoindex for Flask";
    longDescription = ''
      Flask-AutoIndex generates an index page for your Flask application automatically.
      The result is just like mod_autoindex, but the look is more awesome!
    '';
    license = licenses.bsd2;
    maintainers = teams.sage.members;
    homepage = "https://pythonhosted.org/Flask-AutoIndex/";
  };
}
