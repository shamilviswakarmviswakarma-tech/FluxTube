/// Provider-owned pagination state. Treat [token] as opaque; do not parse it
/// in feature UI code.
class PageCursor {
  const PageCursor(this.provider, this.token);

  final String provider;
  final String token;
}
