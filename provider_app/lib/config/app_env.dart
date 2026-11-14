enum Environment { local, dev, stage, prod }

const _baseUrl = "baseUrl";
const _env = "env";

Map<String, dynamic> _config = prodConstants;

void setEnvironment(Environment env) {
  switch (env) {
    case Environment.local:
      _config = localConstants;
    case Environment.dev:
      _config = devConstants;
      break;
    case Environment.stage:
      _config = stageConstants;
      break;
    case Environment.prod:
      _config = prodConstants;
  }
}

dynamic get getEnv {
  return _config[_env];
}

dynamic get apiBaseUrl {
  return _config[_baseUrl];
}

Map<String, dynamic> localConstants = {
  // _baseUrl: "https://be8f0b9f-6d7c-4437-9ce3-9b55657b7e3d.mock.pstmn.io",
  //_baseUrl: "http://192.168.68.117:8080",
  _baseUrl: "http://192.168.68.118:8080",
  _env: Environment.local,
};

Map<String, dynamic> devConstants = {
  // Override at build time, e.g. --dart-define=API_BASE_URL=http://10.0.2.2:8080 (Android emulator -> local server)
  _baseUrl: const String.fromEnvironment("API_BASE_URL", defaultValue: "http://15.207.56.61:8080"),
  _env: Environment.dev,
};

Map<String, dynamic> stageConstants = {_baseUrl: "", _env: Environment.stage};

Map<String, dynamic> prodConstants = {_baseUrl: "", _env: Environment.prod};
