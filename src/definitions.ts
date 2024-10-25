export interface SSLCheckerPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  verify(options: VerifySSLOptions): Promise<{ value: boolean }>;
}

export interface VerifySSLOptions {
  url: string;
  fingerprints: string[];
}
