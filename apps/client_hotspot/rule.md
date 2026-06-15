{
  "rules": {
    "mikrotik_member": {
      "$router_id": {
        // Hanya router dengan Serial Number yang valid yang bisa menulis ke folder miliknya
        ".write": "auth.uid === $router_id || !data.exists() || data.child('secret').val() === newData.child('secret').val()",
        ".read": "auth.uid === $router_id"
      }
    }
  }
}