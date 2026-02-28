const envDmApiPath = 'DM_API_PATH';
const envDmAppId = 'DM_APP_ID';
const envDmPublicKey = 'DM_PUBLIC_KEY';
const envDmLauncherEndpoint = 'DM_LAUNCHER_ENDPOINT';
const envDmLauncherToken = 'DM_LAUNCHER_TOKEN';

const defaultDllName = 'dm_api.dll';
const defaultBufferSize = 256;
const defaultModeBufferSize = 64;

const devLicenseError =
    'Development license is missing or corrupted. Run `distromate sdk renew` to regenerate the dev certificate.';

const activationErrorNames = <int, String>{
  0: 'DM_ERR_OK',
  1: 'DM_ERR_FAIL',
  2: 'DM_ERR_INVALID_PARAMETER',
  3: 'DM_ERR_APPID_NOT_SET',
  4: 'DM_ERR_LICENSE_KEY_NOT_SET',
  5: 'DM_ERR_NOT_ACTIVATED',
  6: 'DM_ERR_LICENSE_EXPIRED',
  7: 'DM_ERR_NETWORK',
  8: 'DM_ERR_FILE_IO',
  9: 'DM_ERR_SIGNATURE',
  10: 'DM_ERR_BUFFER_TOO_SMALL',
};
