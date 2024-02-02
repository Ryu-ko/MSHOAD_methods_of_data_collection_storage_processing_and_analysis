using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void CalculateAverageWithoutMinMax(SqlString values, out double result)
    {
        result = 0;

        if (values.IsNull)
            return;

        string[] stringValues = values.Value.Split(',');

        if (stringValues.Length < 3)
            return;

        double sum = 0;
        double count = 0;
        double max;
        double min;

        if (double.TryParse(stringValues[0], out double currentValue))
        {
            max = currentValue;
            min = currentValue;
        }
        else
        {
            max = 0;
            min = 0;
        }


        for (int i = 0; i < stringValues.Length; i++)
        {
            if (double.TryParse(stringValues[i], out double currentValue2))
            {
                if (currentValue2 > max) max = currentValue2;
                if (currentValue2 < min) min = currentValue2;
            }  
        }

        for (int i = 0; i < stringValues.Length; i++)
        {
            if (double.TryParse(stringValues[i], out double currentValue3))
            {
                if (currentValue3 != max && currentValue3 != min)
                {
                    sum += currentValue3;
                    count++;
                }
            }
        }

        if (count > 2)
            result = sum / count;
    }
}