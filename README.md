# capacitor-plugin-sslchecker

This Capacitor plugin enables you to verify the SSL certificate of a server you're connecting to. By checking the certificate's validity, you can help protect your users from Man-in-the-Middle attacks and ensure secure communication.

## Install

```bash
npm install capacitor-plugin-sslchecker
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`verify(...)`](#verify)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### verify(...)

```typescript
verify(options: VerifySSLOptions) => Promise<{ value: boolean; }>
```

| Param         | Type                                                          |
| ------------- | ------------------------------------------------------------- |
| **`options`** | <code><a href="#verifyssloptions">VerifySSLOptions</a></code> |

**Returns:** <code>Promise&lt;{ value: boolean; }&gt;</code>

--------------------


### Interfaces


#### VerifySSLOptions

| Prop               | Type                  |
| ------------------ | --------------------- |
| **`url`**          | <code>string</code>   |
| **`fingerprints`** | <code>string[]</code> |

</docgen-api>
