using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebApplication1.Models;
using System.Data.SqlClient;
using System.Web.SessionState;
namespace WebApplication1.Controllers
{
    public class LoginController : Controller
    {
        SqlConnection con = new SqlConnection();
        SqlCommand com = new SqlCommand();
        SqlDataReader dr;
        // GET: Login
        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }
        void connectionString()
        {
            con.ConnectionString = "data source=VICTOR\\SQLEXPRESS01; database=Lab9WP; integrated security=SSPI;";
    
        }
        [HttpPost]
        public ActionResult Verify(User user)
        {
            connectionString();
            con.Open();
            com.Connection = con;
            com.CommandText = "select * from Users where username='"+user.username+"' and password='"+user.password+"'";
            dr = com.ExecuteReader();
            if (dr.Read())
            {
                Session["userid"] = Session.SessionID;
                con.Close();
                return RedirectToAction("Index", "Files");
            }
            else
            {
                con.Close();
                return View("Error");
            }
            con.Close();
           
        }
    }
}