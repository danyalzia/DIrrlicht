#include <cirrlicht.h>
#include <irrlicht.h>

void setEventReceiver(irr_IrrlichtDevice* device, irr::IEventReceiver* receiver) {
	reinterpret_cast<irr::IrrlichtDevice*>(device)->setEventReceiver(receiver);
}
