import { WebPlugin } from '@capacitor/core';

import type { SSLCheckerPlugin, VerifySSLOptions } from './definitions';

export class SSLCheckerWeb extends WebPlugin implements SSLCheckerPlugin {
  verify(options: VerifySSLOptions): Promise<{ value: boolean }> {
    console.log('VerifySSLOptions', options);
    throw new Error('Method not implemented.');
  }
}
