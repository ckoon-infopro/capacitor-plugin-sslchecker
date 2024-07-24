export interface SSLCheckerPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
