using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

[Serializable]
[SqlUserDefinedType(Format.UserDefined, IsByteOrdered = true, MaxByteSize = 8000)]
// Specifies that the type uses a user-defined serialization format.
public struct Address : IBinarySerialize, INullable
{
    private string street;
    private string city;
    private string state;
    private bool isNull;

    public bool IsNull => isNull;

    public static Address Null => new Address { isNull = true };

    public string Street
    {
        get { return street; }
        set { street = value; }
    }

    public string City
    {
        get { return city; }
        set { city = value; }
    }

    public string State
    {
        get { return state; }
        set { state = value; }
    }

    // Read reads the binary representation and sets the fields accordingly.
    public void Read( System.IO.BinaryReader r )
    {
        if (r != null)
        {
            street = r.ReadString();
            city = r.ReadString();
            state = r.ReadString();
        }
    }

    // Write writes the binary representation based on the current state of the instance.
    public void Write( System.IO.BinaryWriter w )
    {
        if (w != null)
        {
            w.Write(street);
            w.Write(city);
            w.Write(state);
        }
    }

    public override string ToString()
    {
        return isNull ? "NULL" : $"{street}, {city}, {state}";
    }

    // Add the required Parse method
    public static Address Parse( SqlString s )
    {
        if (s.IsNull)
            return Null;

        string[] parts = s.Value.Split(',');

        if (parts.Length != 3)
            throw new ArgumentException("Invalid format. Use 'Street, City, State'.");

        Address address = new Address();
        address.Street = parts[0].Trim();
        address.City = parts[1].Trim();
        address.State = parts[2].Trim();

        return address;

    }
}
