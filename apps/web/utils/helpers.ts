export function encodeUrl(url: string): Buffer {
  const [baseUrl, queryString] = url.split("?");
  const encodedBaseUrl = encodeURIComponent(baseUrl);

  if (!queryString) {
    const buffer = Buffer.from(encodedBaseUrl, "utf-8");
    return buffer;
  }

  const encodedQueryParams = queryString
    .split("&")
    .map((param) => {
      const [key, value] = param.split("=");
      const encodedKey = encodeURIComponent(key);
      const encodedValue = encodeURIComponent(value);
      return `${encodedKey}=${encodedValue}`;
    })
    .join("&");

  const encodedQueryString = `${encodedBaseUrl}?${encodedQueryParams}`;
  const buffer = Buffer.from(encodedQueryString, "utf-8");

  return buffer;
}
