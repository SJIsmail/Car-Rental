using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace Transaction
{
	class Database
	{
		readonly string connString = @"Data Source = (LocalDB)\MSSQLLocalDB;AttachDbFilename=D:\Tournaments.mdf;Integrated Security = True; Connect Timeout = 30";
		readonly SqlConnection mConnection;//Create connection channel

		public Database()
		{
			mConnection = new SqlConnection(connString);
			Open();
		}

		private List<Transaction> GetTransactions(params float[] args)
		{
			List<Transaction> TransactionList = new List<Transaction>();

			List<List<object>> RawTransactions = Execute(ComposeSQL(args));

			for (int i = 0; i < RawTransactions.Count; i++)
			{
				Transaction transaction = new Transaction();
				transaction.TransactionID = Convert.ToInt32(RawTransactions[i][0]);
				transaction.LateCoast = Convert.ToSingle(RawTransactions[i][1]);
				transaction.BaseCost = Convert.ToSingle(RawTransactions[i][2]);
				transaction.ReturnCoast = Convert.ToSingle(RawTransactions[i][3]);

				TransactionList.Add(transaction);
			}

			return TransactionList;
		}

		private bool AllZero(float[] args)
		{
			foreach (float item in args)
			{
				if (item > 0)
					return false;
			}

			return true;
		}

		private string ComposeSQL(params float[] args)
		{
			if (args.Length == 0 || AllZero(args))
				return "select * from Transaction";

			string sql = "select * from Transaction where ";

			if (args[0] > 0)
			{
				sql += "LastCost >= " + args[0];
			}

			if (args[1] > 0)
			{
				sql += " and LastCost < " + args[1];
			}

			if (args[2] > 0)
			{
				sql += " and BaseCost >= " + args[2];
			}

			if (args[3] > 0)
			{
				sql += " and BaseCost < " + args[3];
			}

			if (args[4] > 0)
			{
				sql += " and ReturnCost >= " + args[4];
			}

			if (args[5] > 0)
			{
				sql += " and ReturnCoast < " + args[5];
			}

			return sql;
		}

		private int ExecuteNonQuery(string sql)
		{
			return new SqlCommand(sql, mConnection).ExecuteNonQuery();
		}

		private List<List<object>> Execute(string sql)
		{
			List<List<object>> queriedList = new List<List<object>>();

			SqlCommand command = new SqlCommand
			{
				Connection = mConnection,
				CommandType = CommandType.Text,
				CommandText = sql
			};
			SqlDataReader reader = command.ExecuteReader();     //Execute the SQL and return a “stream”
			while (reader.Read())
			{
				int columns = reader.VisibleFieldCount;
				List<object> tempList = new List<object>();

				for (int i = 0; i < columns; i++)
				{
					tempList.Add(reader[i]);
				}

				queriedList.Add(tempList);
			}
			reader.Close();

			return queriedList;
		}

		private void Open()
		{
			try
			{
				mConnection.Open();
			}
			catch (Exception exception)
			{
				MessageBox.Show(exception.ToString());
			}
		}

		private void Close()
		{
			try
			{
				if (mConnection != null)
				{
					mConnection.Close();
				}
			}
			catch (Exception)
			{ }
		}

		~Database()
		{
			Close();
		}
	}
}