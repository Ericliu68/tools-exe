from rediscluster import RedisCluster
startup_nodes = [
    {"host": "127.0.0.1", "port": "7001"},
    {"host": "127.0.0.1", "port": "7002"},
    {"host": "127.0.0.1", "port": "7003"},
    {"host": "127.0.0.1", "port": "7004"},
    {"host": "127.0.0.1", "port": "7005"},
    {"host": "127.0.0.1", "port": "7006"},
    {"host": "127.0.0.1", "port": "7007"},
    {"host": "127.0.0.1", "port": "7008"},
    {"host": "127.0.0.1", "port": "7009"},
    {"host": "127.0.0.1", "port": "70010"},
    {"host": "127.0.0.1", "port": "70011"},
    {"host": "127.0.0.1", "port": "70012"},
    ]

rc = RedisCluster(startup_nodes=startup_nodes, decode_responses=True, password="909090")
print(rc.set("foo", "bar"))
print(rc.get("foo"))
