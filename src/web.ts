import { WebPlugin } from '@capacitor/core';

import type { SSLCheckerPlugin } from './definitions';

export class SSLCheckerWeb extends WebPlugin implements SSLCheckerPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
