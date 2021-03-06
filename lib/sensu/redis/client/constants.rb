module Sensu
  module Redis
    # RESP (REdis Serialization Protocol) response type characters and
    # delimiter (http://redis.io/topics/protocol).
    OK = "OK".freeze
    MINUS = "-".freeze
    PLUS = "+".freeze
    COLON = ":".freeze
    DOLLAR = "$".freeze
    ASTERISK = "*".freeze
    DELIM = "\r\n".freeze

    # Redis response line parser incomplete data return value.
    INCOMPLETE = "incomp".freeze

    # Redis response boolean values.
    TRUE_VALUES = %w[1 OK].freeze

    # Redis pubsub response type values.
    PUBSUB_RESPONSES = %w[message unsubscribe].freeze

    # Redis commands that are supported by this library.
    COMMANDS = [
      "ping",
      "set",
      "setnx",
      "get",
      "getset",
      "del",
      "mget",
      "info",
      "sadd",
      "smembers",
      "sismember",
      "srem",
      "scard",
      "hset",
      "hsetnx",
      "hget",
      "hgetall",
      "hdel",
      "hincrby",
      "rpush",
      "lpush",
      "rpop",
      "blpop",
      "ltrim",
      "lrange",
      "llen",
      "exists",
      "hexists",
      "ttl",
      "expire",
      "flushdb",
      "incr",
      "multi",
      "exec",
      "publish"
    ].freeze

    # Redis commands.
    AUTH_COMMAND = "auth".freeze
    SELECT_COMMAND = "select".freeze
    INFO_COMMAND = "info".freeze
    SUBSCRIBE_COMMAND = "subscribe".freeze
    UNSUBSCRIBE_COMMAND = "unsubscribe".freeze

    # Boolean Redis response value processor.
    BOOLEAN_PROCESSOR = lambda{|r| TRUE_VALUES.include?(r.to_s)}

    # Redis response value processors.
    RESPONSE_PROCESSORS = {
      "auth" => BOOLEAN_PROCESSOR,
      "exists" => BOOLEAN_PROCESSOR,
      "hexists" => BOOLEAN_PROCESSOR,
      "sismember" => BOOLEAN_PROCESSOR,
      "sadd" => BOOLEAN_PROCESSOR,
      "srem" => BOOLEAN_PROCESSOR,
      "setnx" => BOOLEAN_PROCESSOR,
      "del" => BOOLEAN_PROCESSOR,
      "expire" => BOOLEAN_PROCESSOR,
      "select" => BOOLEAN_PROCESSOR,
      "hset" => BOOLEAN_PROCESSOR,
      "hdel" => BOOLEAN_PROCESSOR,
      "hsetnx" => BOOLEAN_PROCESSOR,
      "hgetall" => lambda{|r| Hash[*r]},
      "info" => lambda{|r|
        info = {}
        r.each_line do |line|
          line.chomp!
          unless line.empty?
            k, v = line.split(":", 2)
            info[k.to_sym] = v
          end
        end
        info
      }
    }
  end
end
