import { WebPlugin } from '@capacitor/core';

import type { SSLCheckerPlugin, VerifySSLOptions } from './definitions';

export class SSLCheckerWeb extends WebPlugin implements SSLCheckerPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  verify(options: VerifySSLOptions): Promise<{ value: boolean }> {
    console.log('VerifySSLOptions', options);
    throw new Error('Method not implemented.');
  }
}
