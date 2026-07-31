// 在三台节点均已按 mongod-node.conf.template 启动后执行。
// 请将 host 地址替换为实际内网 DNS 或固定 IP。
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongo-01.internal.example:27017", priority: 2 },
    { _id: 1, host: "mongo-02.internal.example:27017", priority: 1 },
    { _id: 2, host: "mongo-03.internal.example:27017", priority: 1 }
  ]
});

// 初始化后，使用 admin 用户登录并创建最小权限的业务账号。
