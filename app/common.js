/**
 * Common functions for HR Portal
 */

// Mock data for employees
const mockEmployees = [
  {
    id: 1,
    name: "John Smith",
    email: "john.smith@company.com",
    department: "Engineering",
    position: "Senior Developer",
    status: "Active",
    joinDate: "2020-05-15"
  },
  {
    id: 2,
    name: "Sarah Johnson",
    email: "sarah.j@company.com",
    department: "Marketing",
    position: "Marketing Manager",
    status: "Active",
    joinDate: "2019-11-20"
  },
  {
    id: 3,
    name: "Michael Brown",
    email: "michael.b@company.com",
    department: "Sales",
    position: "Account Executive",
    status: "Active",
    joinDate: "2021-02-10"
  }
];

// Mock data for leaves
const mockLeaves = [
  {
    id: 1,
    employeeId: 2,
    employeeName: "Sarah Johnson",
    type: "Vacation",
    startDate: "2023-06-10",
    endDate: "2023-06-17",
    status: "Approved",
    reason: "Family vacation"
  },
  {
    id: 2,
    employeeId: 3,
    employeeName: "Michael Brown",
    type: "Sick",
    startDate: "2023-06-05",
    endDate: "2023-06-07",
    status: "Pending",
    reason: "Flu symptoms"
  }
];

// Authentication functions
const Auth = {
  isAuthenticated: function() {
    return localStorage.getItem('authToken') !== null;
  },
  logout: function() {
    localStorage.removeItem('authToken');
    window.location.href = 'index.html';
  }
};

// API Mock functions
const API = {
  getEmployees: function() {
    return new Promise(resolve => {
      setTimeout(() => resolve(mockEmployees), 500);
    });
  },
  getLeaves: function() {
    return new Promise(resolve => {
      setTimeout(() => resolve(mockLeaves), 500);
    });
  },
  approveLeave: function(leaveId) {
    return new Promise(resolve => {
      setTimeout(() => {
        const leave = mockLeaves.find(l => l.id === leaveId);
        if (leave) leave.status = 'Approved';
        resolve({ success: true });
      }, 300);
    });
  }
};

// Utility functions
const Utils = {
  formatDate: function(dateString) {
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('en-US', options);
  },
  showToast: function(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `fixed top-4 right-4 px-6 py-3 rounded-md shadow-lg text-white ${
      type === 'success' ? 'bg-green-500' : 'bg-red-500'
    }`;
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => {
      toast.remove();
    }, 3000);
  }
};

// Initialize common functionality when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Add logout functionality to all logout buttons
  document.querySelectorAll('[data-logout]').forEach(button => {
    button.addEventListener('click', Auth.logout);
  });
  
  // Check authentication on protected pages
  if (!window.location.pathname.includes('index.html') && !Auth.isAuthenticated()) {
    window.location.href = 'index.html';
  }
});