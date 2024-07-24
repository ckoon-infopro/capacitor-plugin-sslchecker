import { registerPlugin } from '@capacitor/core';

import type { SSLCheckerPlugin } from './definitions';

const SSLChecker = registerPlugin<SSLCheckerPlugin>('SSLChecker', {
  web: () => import('./web').then(m => new m.SSLCheckerWeb()),
});

export * from './definitions';
export { SSLChecker };
