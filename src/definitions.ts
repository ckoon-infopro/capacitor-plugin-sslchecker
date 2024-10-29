export interface SSLCheckerPlugin {
  verify(options: VerifySSLOptions): Promise<{ value: boolean }>;
}

export interface VerifySSLOptions {
  url: string;
  fingerprints: string[];
}
