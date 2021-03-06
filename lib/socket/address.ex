#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Socket.Address do
  @type t :: String.t | char_list | :inet.ip_address

  @doc """
  Parse a string to an ip address tuple.
  """
  @spec parse(t) :: :inet.ip_address
  def parse(text) when is_binary(text) do
    parse(binary_to_list(text))
  end

  def parse(text) when is_list(text) do
    case :inet.parse_address(text) do
      { :ok, ip } ->
        ip

      { :error, :einval } ->
        nil
    end
  end

  def parse(address) do
    address
  end

  @doc """
  Get the addresses for the given host.
  """
  @spec for(t, :inet.address_family) :: { :ok, [t] } | { :error, :inet.posix }
  def for(host, family) do
    :inet.getaddrs(parse(host), family)
  end

  @doc """
  Get the addresses for the given host, raising if an error occurs.
  """
  @spec for!(t, :inet.address_family) :: [t] | no_return
  def for!(host, family) do
    case :inet.getaddrs(parse(host), family) do
      { :ok, addresses } ->
        addresses

      { :error, code } ->
        raise PosixError, code: code
    end
  end
end
