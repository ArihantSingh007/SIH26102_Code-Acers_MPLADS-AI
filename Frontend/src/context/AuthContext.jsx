import React, { createContext, useContext, useState, useEffect } from 'react';
import { ROLES, DEMO_USERS } from '../utils/constants';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(() => {
    const saved = localStorage.getItem('mplads_auth_user');
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch (e) {
        return null;
      }
    }
    return null; // Public guest by default
  });

  const [role, setRole] = useState(() => {
    return user?.role || ROLES.CITIZEN;
  });

  useEffect(() => {
    if (user) {
      localStorage.setItem('mplads_auth_user', JSON.stringify(user));
      setRole(user.role);
    } else {
      localStorage.removeItem('mplads_auth_user');
    }
  }, [user]);

  const login = async (email, password, selectedRole) => {
    const cleanEmail = (email || '').toLowerCase().trim();
    const cleanRole = (selectedRole || '').toLowerCase().trim();

    // 1. Direct email lookup
    let matchedUser = DEMO_USERS.find(
      u => u.email.toLowerCase() === cleanEmail || (u.alternateEmail && u.alternateEmail.toLowerCase() === cleanEmail)
    );

    // 2. Role-based lookup
    if (!matchedUser) {
      let effectiveRole = cleanRole;
      if (cleanRole.includes('admin') || cleanRole.includes('mospi') || cleanEmail.includes('admin') || cleanEmail.includes('mospi')) {
        effectiveRole = ROLES.MOSPI_ADMIN;
      } else if (cleanRole.includes('district') || cleanRole.includes('officer') || cleanEmail.includes('district') || cleanEmail.includes('collector') || cleanEmail.includes('varanasi') || cleanEmail.includes('dm')) {
        effectiveRole = ROLES.DISTRICT_OFFICER;
      } else {
        effectiveRole = ROLES.CITIZEN;
      }

      matchedUser = DEMO_USERS.find(u => u.role === effectiveRole);
    }

    // 3. Fallback deterministic generator
    if (!matchedUser) {
      const isAdm = cleanRole.includes('admin') || cleanRole.includes('mospi') || cleanEmail.includes('admin') || cleanEmail.includes('mospi');
      const isDist = cleanRole.includes('district') || cleanRole.includes('officer') || cleanEmail.includes('district') || cleanEmail.includes('collector') || cleanEmail.includes('dm');
      matchedUser = {
        id: `USR-${Date.now()}`,
        email: cleanEmail || (isAdm ? 'admin.mospi@gov.in' : isDist ? 'collector.varanasi@gov.in' : 'citizen.patel@gmail.com'),
        name: isAdm ? 'Dr. Rajeshwar Sharma' : isDist ? 'Priyanka Verma, IAS' : 'Amit Patel',
        role: isAdm ? ROLES.MOSPI_ADMIN : isDist ? ROLES.DISTRICT_OFFICER : ROLES.CITIZEN,
        badge: isAdm ? 'Central MoSPI Admin' : isDist ? 'District Officer' : 'Citizen Explorer',
      };
    }

    setUser(matchedUser);
    setRole(matchedUser.role);
    localStorage.setItem('mplads_auth_user', JSON.stringify(matchedUser));
    return { success: true, user: matchedUser };
  };


  const switchRole = (newRole) => {
    const targetUser = DEMO_USERS.find(u => u.role === newRole) || {
      id: `USR-${newRole}`,
      name: newRole === ROLES.MOSPI_ADMIN ? 'Dr. Rajeshwar Sharma' : newRole === ROLES.DISTRICT_OFFICER ? 'Priyanka Verma, IAS' : 'Amit Patel',
      email: `${newRole}@gov.in`,
      role: newRole,
      badge: newRole,
    };
    setUser(targetUser);
    setRole(newRole);
  };

  const logout = () => {
    setUser(null);
    setRole(null);
    localStorage.removeItem('mplads_auth_user');
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        role,
        isAuthenticated: !!user,
        isAdmin: role === ROLES.MOSPI_ADMIN,
        isDistrictOfficer: role === ROLES.DISTRICT_OFFICER,
        isCitizen: role === ROLES.CITIZEN,
        login,
        logout,
        switchRole,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
