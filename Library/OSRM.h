/*
    open source routing machine
    Copyright (C) Dennis Luxen, 2010

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU AFFERO General Public License as published by
the Free Software Foundation; either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
or see http://www.gnu.org/licenses/agpl.txt.
 */

#ifndef OSRM_H
#define OSRM_H

#include "OSRM.h"

#include "../Plugins/BasePlugin.h"
#include "../Plugins/HelloWorldPlugin.h"
#include "../Plugins/LocatePlugin.h"
#include "../Plugins/NearestPlugin.h"
#include "../Plugins/TimestampPlugin.h"
#include "../Plugins/ViaRoutePlugin.h"
#include "../Plugins/RouteParameters.h"
#include "../Util/BaseConfiguration.h"
#include "../Util/InputFileUtil.h"
#include "../Server/BasicDatastructures.h"

#include <boost/assert.hpp>
#include <boost/noncopyable.hpp>
#include <boost/thread.hpp>

#include <exception>
#include <vector>

class OSRMException: public std::exception {
public:
    OSRMException(const char * message) : message(message) {}
private:
    virtual const char* what() const throw() {
        return message;
    }
    const char * message;
};

class OSRM : boost::noncopyable {
    typedef boost::unordered_map<std::string, BasePlugin *> PluginMap;
    QueryObjectsStorage * objects;
public:
    OSRM(const char * server_ini_path);
    ~OSRM();
    void RunQuery(RouteParameters & route_parameters, http::Reply & reply);
private:
    void RegisterPlugin(BasePlugin * plugin);
    PluginMap pluginMap;
};

#endif //OSRM_H