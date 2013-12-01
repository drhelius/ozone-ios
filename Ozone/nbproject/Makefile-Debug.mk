#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Environment
MKDIR=mkdir
CP=cp
CCADMIN=CCadmin
RANLIB=ranlib
CC=gcc
CCC=g++
CXX=g++
FC=gfortran
AS=as

# Macros
CND_PLATFORM=GNU-Linux-x86
CND_CONF=Debug
CND_DISTDIR=dist

# Include project Makefile
include Makefile

# Object Directory
OBJECTDIR=build/${CND_CONF}/${CND_PLATFORM}

# Object Files
OBJECTFILES= \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereTriangleCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/gem.o \
	${OBJECTDIR}/Classes/OzoneAppDelegate.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btDiscreteDynamicsWorld.o \
	${OBJECTDIR}/Classes/Ozone/Bitset.o \
	${OBJECTDIR}/Classes/Ozone/math/Transform.o \
	${OBJECTDIR}/Classes/Ozone/airpumpplace.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btUniformScalingShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btContinuousConvexCollision.o \
	${OBJECTDIR}/Classes/Ozone/audiomanager.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btMinkowskiPenetrationDepthSolver.o \
	${OBJECTDIR}/Classes/Ozone/bounceenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Character/btKinematicCharacterController.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btActivatingCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyHelpers.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConvexAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/decoration.o \
	${OBJECTDIR}/Classes/Ozone/bluekey.o \
	${OBJECTDIR}/Classes/Ozone/backgroundparticle.o \
	${OBJECTDIR}/Classes/Ozone/fader.o \
	${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btGeometryUtil.o \
	${OBJECTDIR}/Classes/Ozone/SubMenuLevelSelectionState.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/Bullet-C-API.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.o \
	${OBJECTDIR}/Classes/Ozone/http/HTTPAuthenticationRequest.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCylinderShape.o \
	${OBJECTDIR}/Classes/Ozone/place.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGenericPoolAllocator.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btAxisSweep3.o \
	${OBJECTDIR}/Classes/Ozone/SubMenuFullVersionState.o \
	${OBJECTDIR}/Classes/Ozone/item.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofSpringConstraint.o \
	${OBJECTDIR}/Classes/Ozone/movingcubeenemy.o \
	${OBJECTDIR}/Classes/Ozone/enemyparticle.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btGhostObject.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionDispatcher.o \
	${OBJECTDIR}/Classes/Ozone/gasparticle.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleCallback.o \
	${OBJECTDIR}/Classes/Ozone/moveable.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConcaveShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btPersistentManifold.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btUniversalConstraint.o \
	${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btConvexHull.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btSimpleBroadphase.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btConvexCast.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSimulationIslandManager.o \
	${OBJECTDIR}/Classes/Ozone/enemy.o \
	${OBJECTDIR}/Classes/Ozone/spittingenemy.o \
	${OBJECTDIR}/Classes/Ozone/cube.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSliderConstraint.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/BossOceanEnemy.o \
	${OBJECTDIR}/Classes/Ozone/InGameMenuText.o \
	${OBJECTDIR}/Classes/Ozone/smokeparticle.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultiSphereShape.o \
	${OBJECTDIR}/Classes/Ozone/renderobject.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexInternalShape.o \
	${OBJECTDIR}/Classes/Ozone/math/Vector.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHinge2Constraint.o \
	${OBJECTDIR}/Classes/Ozone/http/DDData.o \
	${OBJECTDIR}/Classes/Ozone/BossVulcanEnemy.o \
	${OBJECTDIR}/Classes/Ozone/npc.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btRaycastCallback.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btSphereShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactShape.o \
	${OBJECTDIR}/Classes/Ozone/lancesenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btSubSimplexConvexCast.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxDetector.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btShapeHull.o \
	${OBJECTDIR}/Classes/Ozone/parsermanager.o \
	${OBJECTDIR}/Classes/Ozone/InGameMenuEndLevel.o \
	${OBJECTDIR}/Classes/Ozone/http/HTTPConnection.o \
	${OBJECTDIR}/Classes/Ozone/submenumainstate.o \
	${OBJECTDIR}/Classes/Ozone/particlemanager.o \
	${OBJECTDIR}/Classes/Ozone/SubMenuHelpState.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_memory.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyConcaveCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConcaveCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/menuitem.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btEmptyShape.o \
	${OBJECTDIR}/Classes/Ozone/nucleargem.o \
	${OBJECTDIR}/Classes/Ozone/renderer.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkConvexCast.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btOptimizedBvh.o \
	${OBJECTDIR}/Classes/Ozone/conveyorbeltplace.o \
	${OBJECTDIR}/Classes/Ozone/physicsmanager.o \
	${OBJECTDIR}/Classes/Ozone/redgem.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCollisionShape.o \
	${OBJECTDIR}/Classes/Ozone/key.o \
	${OBJECTDIR}/Classes/Ozone/SubMenuSaveSelectionState.o \
	${OBJECTDIR}/Classes/EAGLView.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereSphereCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btVoronoiSimplexSolver.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btTypedConstraint.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofConstraint.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyRigidBodyCollisionConfiguration.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultimaterialTriangleMeshShape.o \
	${OBJECTDIR}/Classes/Ozone/SubMenuHighScoresState.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btBvhTriangleMeshShape.o \
	${OBJECTDIR}/Classes/Ozone/spittingenemyshotparticle.o \
	${OBJECTDIR}/Classes/Ozone/electricenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btRigidBody.o \
	${OBJECTDIR}/Classes/Ozone/scenetrigger.o \
	${OBJECTDIR}/Classes/Ozone/math/vfpmath/matrix_impl.o \
	${OBJECTDIR}/Classes/Ozone/searchthrowingenemy.o \
	${OBJECTDIR}/Classes/Ozone/yellowgem.o \
	${OBJECTDIR}/Classes/Ozone/triggermanager.o \
	${OBJECTDIR}/Classes/Ozone/SubMenuAwardsState.o \
	${OBJECTDIR}/Classes/Ozone/playerredshotparticle.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBody.o \
	${OBJECTDIR}/Classes/Ozone/InGameMenuDie.o \
	${OBJECTDIR}/Classes/Ozone/texture.o \
	${OBJECTDIR}/Classes/Ozone/movingwallenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btUnionFind.o \
	${OBJECTDIR}/Classes/Ozone/backgrounds.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btContactConstraint.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/SphereTriangleDetector.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Vehicle/btWheelInfo.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleBuffer.o \
	${OBJECTDIR}/Classes/Ozone/textfont.o \
	${OBJECTDIR}/Classes/Ozone/http/HTTPServer.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexTriangleMeshShape.o \
	${OBJECTDIR}/Classes/Ozone/mesh.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvt.o \
	${OBJECTDIR}/Classes/Ozone/greengem.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvtBroadphase.o \
	${OBJECTDIR}/Classes/Ozone/particle.o \
	${OBJECTDIR}/Classes/Ozone/exitplace.o \
	${OBJECTDIR}/Classes/Ozone/levelgamestate.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btMultiSapBroadphase.o \
	${OBJECTDIR}/Classes/Ozone/electricgem.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMinkowskiSumShape.o \
	${OBJECTDIR}/Classes/Ozone/UIManager.o \
	${OBJECTDIR}/Classes/Ozone/texturemanager.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConeShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btQuickprof.o \
	${OBJECTDIR}/Classes/Ozone/redkey.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHingeConstraint.o \
	${OBJECTDIR}/Classes/Ozone/spikegroupenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btConeTwistConstraint.o \
	${OBJECTDIR}/Classes/Ozone/Result.o \
	${OBJECTDIR}/Classes/Ozone/bluegem.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactQuantizedBvh.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexArray.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btPoint2PointConstraint.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDispatcher.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btHeightfieldTerrainShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btContinuousDynamicsWorld.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btOverlappingPairCache.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactBvh.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_contact.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionObject.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btTriangleShapeEx.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_tri_collision.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTetrahedronShape.o \
	${OBJECTDIR}/Classes/Ozone/math/neonmath/neon_matrix_impl.o \
	${OBJECTDIR}/Classes/Ozone/timer.o \
	${OBJECTDIR}/Classes/Ozone/searchenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMesh.o \
	${OBJECTDIR}/Classes/Ozone/inlinethrowingenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btStridingMeshInterface.o \
	${OBJECTDIR}/Classes/Ozone/http/HTTPResponse.o \
	${OBJECTDIR}/Classes/Ozone/spikeenemy.o \
	${OBJECTDIR}/Classes/Ozone/movingcrosssmallenemy.o \
	${OBJECTDIR}/Classes/Ozone/BossSpaceEnemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btManifoldResult.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btEmptyCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/submenuepisodeselectionstate.o \
	${OBJECTDIR}/Classes/Ozone/menugamestate.o \
	${OBJECTDIR}/Classes/Ozone/teleporterplace.o \
	${OBJECTDIR}/Classes/Ozone/sound/SoundEngine.o \
	${OBJECTDIR}/Classes/Ozone/scene.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCompoundShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_box_set.o \
	${OBJECTDIR}/Classes/Ozone/startplace.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpa2.o \
	${OBJECTDIR}/Classes/Ozone/ScoresView.o \
	${OBJECTDIR}/Classes/Ozone/itemparticle.o \
	${OBJECTDIR}/Classes/Ozone/introgamestate.o \
	${OBJECTDIR}/Classes/Ozone/sector.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMeshShape.o \
	${OBJECTDIR}/Classes/Ozone/npcfactory.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSolve2LinearConstraint.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Vehicle/btRaycastVehicle.o \
	${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btAlignedAllocator.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btBoxShape.o \
	${OBJECTDIR}/Classes/Ozone/episode.o \
	${OBJECTDIR}/Classes/Ozone/BossEarthEnemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btStaticPlaneShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCompoundCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/meshmanager.o \
	${OBJECTDIR}/Classes/Ozone/bladeenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexHullShape.o \
	${OBJECTDIR}/Classes/Ozone/InGameMenuMain.o \
	${OBJECTDIR}/Classes/Ozone/ScoreController.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btQuantizedBvh.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btContactProcessing.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftSoftCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/math/Matrix.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexPlaneCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/BossSpaceShotParticle.o \
	${OBJECTDIR}/Classes/Ozone/inputmanager.o \
	${OBJECTDIR}/Classes/Ozone/gamemanager.o \
	${OBJECTDIR}/Classes/Ozone/camera.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCapsuleShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexPointCloudShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btBroadphaseProxy.o \
	${OBJECTDIR}/Classes/Ozone/inlinethrowingenemyshotparticle.o \
	${OBJECTDIR}/Classes/Ozone/SubMenuCreditsState.o \
	${OBJECTDIR}/Classes/Ozone/http/DDNumber.o \
	${OBJECTDIR}/Classes/Ozone/searchthrowingenemyshotparticle.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btScaledBvhTriangleMeshShape.o \
	${OBJECTDIR}/Classes/Ozone/movingcrossenemy.o \
	${OBJECTDIR}/Classes/Ozone/hud.o \
	${OBJECTDIR}/Classes/Ozone/armenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btSimpleDynamicsWorld.o \
	${OBJECTDIR}/Classes/Ozone/player.o \
	${OBJECTDIR}/Classes/Ozone/interpolatormanager.o \
	${OBJECTDIR}/Classes/Ozone/math/vfpmath/utility_impl.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btPolyhedralConvexShape.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpaPenetrationDepthSolver.o \
	${OBJECTDIR}/Classes/Ozone/http/AsyncSocket.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/InGameMenu.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereBoxCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/HelpButton.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexMaterialArray.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionWorld.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftRigidDynamicsWorld.o \
	${OBJECTDIR}/Classes/Ozone/SubMenuOptionsState.o \
	${OBJECTDIR}/Classes/Ozone/http/DDRange.o \
	${OBJECTDIR}/Classes/Ozone/multibladeenemy.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkPairDetector.o \
	${OBJECTDIR}/Classes/Ozone/SaveManager.o \
	${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftRigidCollisionAlgorithm.o \
	${OBJECTDIR}/Classes/Ozone/physicsdebugdrawer.o

# C Compiler Flags
CFLAGS=

# CC Compiler Flags
CCFLAGS=
CXXFLAGS=

# Fortran Compiler Flags
FFLAGS=

# Assembler Flags
ASFLAGS=

# Link Libraries and Options
LDLIBSOPTIONS=

# Build Targets
.build-conf: ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-Debug.mk dist/Debug/GNU-Linux-x86/ozone

dist/Debug/GNU-Linux-x86/ozone: ${OBJECTFILES}
	${MKDIR} -p dist/Debug/GNU-Linux-x86
	${LINK.cc} -o ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/ozone ${OBJECTFILES} ${LDLIBSOPTIONS} 

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereTriangleCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereTriangleCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereTriangleCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereTriangleCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/gem.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/gem.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/gem.o Classes/Ozone/gem.mm

${OBJECTDIR}/Classes/OzoneAppDelegate.o: nbproject/Makefile-${CND_CONF}.mk Classes/OzoneAppDelegate.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/OzoneAppDelegate.o Classes/OzoneAppDelegate.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btDiscreteDynamicsWorld.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/Dynamics/btDiscreteDynamicsWorld.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btDiscreteDynamicsWorld.o Classes/Ozone/physics/BulletDynamics/Dynamics/btDiscreteDynamicsWorld.cpp

${OBJECTDIR}/Classes/Ozone/Bitset.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/Bitset.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/Bitset.o Classes/Ozone/Bitset.mm

${OBJECTDIR}/Classes/Ozone/math/Transform.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/math/Transform.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/math
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/math/Transform.o Classes/Ozone/math/Transform.cpp

${OBJECTDIR}/Classes/Ozone/airpumpplace.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/airpumpplace.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/airpumpplace.o Classes/Ozone/airpumpplace.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btUniformScalingShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btUniformScalingShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btUniformScalingShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btUniformScalingShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btContinuousConvexCollision.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btContinuousConvexCollision.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btContinuousConvexCollision.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btContinuousConvexCollision.cpp

${OBJECTDIR}/Classes/Ozone/audiomanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/audiomanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/audiomanager.o Classes/Ozone/audiomanager.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btMinkowskiPenetrationDepthSolver.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btMinkowskiPenetrationDepthSolver.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btMinkowskiPenetrationDepthSolver.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btMinkowskiPenetrationDepthSolver.cpp

${OBJECTDIR}/Classes/Ozone/bounceenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/bounceenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/bounceenemy.o Classes/Ozone/bounceenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Character/btKinematicCharacterController.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/Character/btKinematicCharacterController.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Character
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Character/btKinematicCharacterController.o Classes/Ozone/physics/BulletDynamics/Character/btKinematicCharacterController.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btActivatingCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btActivatingCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btActivatingCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btActivatingCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyHelpers.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletSoftBody/btSoftBodyHelpers.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyHelpers.o Classes/Ozone/physics/BulletSoftBody/btSoftBodyHelpers.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConvexAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConvexAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConvexAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConvexAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/decoration.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/decoration.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/decoration.o Classes/Ozone/decoration.mm

${OBJECTDIR}/Classes/Ozone/bluekey.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/bluekey.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/bluekey.o Classes/Ozone/bluekey.mm

${OBJECTDIR}/Classes/Ozone/backgroundparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/backgroundparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/backgroundparticle.o Classes/Ozone/backgroundparticle.mm

${OBJECTDIR}/Classes/Ozone/fader.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/fader.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/fader.o Classes/Ozone/fader.mm

${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btGeometryUtil.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/LinearMath/btGeometryUtil.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/LinearMath
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btGeometryUtil.o Classes/Ozone/physics/LinearMath/btGeometryUtil.cpp

${OBJECTDIR}/Classes/Ozone/SubMenuLevelSelectionState.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SubMenuLevelSelectionState.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SubMenuLevelSelectionState.o Classes/Ozone/SubMenuLevelSelectionState.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/Bullet-C-API.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/Dynamics/Bullet-C-API.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/Bullet-C-API.o Classes/Ozone/physics/BulletDynamics/Dynamics/Bullet-C-API.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.cpp

${OBJECTDIR}/Classes/Ozone/http/HTTPAuthenticationRequest.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/http/HTTPAuthenticationRequest.m 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/http
	${RM} $@.d
	$(COMPILE.c) -g -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/http/HTTPAuthenticationRequest.o Classes/Ozone/http/HTTPAuthenticationRequest.m

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCylinderShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btCylinderShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCylinderShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btCylinderShape.cpp

${OBJECTDIR}/Classes/Ozone/place.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/place.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/place.o Classes/Ozone/place.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGenericPoolAllocator.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/btGenericPoolAllocator.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGenericPoolAllocator.o Classes/Ozone/physics/BulletCollision/Gimpact/btGenericPoolAllocator.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btAxisSweep3.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btAxisSweep3.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btAxisSweep3.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btAxisSweep3.cpp

${OBJECTDIR}/Classes/Ozone/SubMenuFullVersionState.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SubMenuFullVersionState.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SubMenuFullVersionState.o Classes/Ozone/SubMenuFullVersionState.mm

${OBJECTDIR}/Classes/Ozone/item.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/item.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/item.o Classes/Ozone/item.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofSpringConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofSpringConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofSpringConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofSpringConstraint.cpp

${OBJECTDIR}/Classes/Ozone/movingcubeenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/movingcubeenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/movingcubeenemy.o Classes/Ozone/movingcubeenemy.mm

${OBJECTDIR}/Classes/Ozone/enemyparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/enemyparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/enemyparticle.o Classes/Ozone/enemyparticle.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btGhostObject.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btGhostObject.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btGhostObject.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btGhostObject.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionDispatcher.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionDispatcher.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionDispatcher.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionDispatcher.cpp

${OBJECTDIR}/Classes/Ozone/gasparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/gasparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/gasparticle.o Classes/Ozone/gasparticle.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleCallback.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleCallback.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleCallback.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleCallback.cpp

${OBJECTDIR}/Classes/Ozone/moveable.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/moveable.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/moveable.o Classes/Ozone/moveable.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConcaveShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btConcaveShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConcaveShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btConcaveShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btPersistentManifold.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btPersistentManifold.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btPersistentManifold.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btPersistentManifold.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btUniversalConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btUniversalConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btUniversalConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btUniversalConstraint.cpp

${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btConvexHull.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/LinearMath/btConvexHull.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/LinearMath
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btConvexHull.o Classes/Ozone/physics/LinearMath/btConvexHull.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btSimpleBroadphase.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btSimpleBroadphase.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btSimpleBroadphase.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btSimpleBroadphase.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btConvexCast.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btConvexCast.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btConvexCast.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btConvexCast.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSimulationIslandManager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSimulationIslandManager.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSimulationIslandManager.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSimulationIslandManager.cpp

${OBJECTDIR}/Classes/Ozone/enemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/enemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/enemy.o Classes/Ozone/enemy.mm

${OBJECTDIR}/Classes/Ozone/spittingenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/spittingenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/spittingenemy.o Classes/Ozone/spittingenemy.mm

${OBJECTDIR}/Classes/Ozone/cube.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/cube.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/cube.o Classes/Ozone/cube.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSliderConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSliderConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSliderConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSliderConstraint.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/BossOceanEnemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/BossOceanEnemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/BossOceanEnemy.o Classes/Ozone/BossOceanEnemy.mm

${OBJECTDIR}/Classes/Ozone/InGameMenuText.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/InGameMenuText.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/InGameMenuText.o Classes/Ozone/InGameMenuText.mm

${OBJECTDIR}/Classes/Ozone/smokeparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/smokeparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/smokeparticle.o Classes/Ozone/smokeparticle.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultiSphereShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultiSphereShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultiSphereShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultiSphereShape.cpp

${OBJECTDIR}/Classes/Ozone/renderobject.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/renderobject.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/renderobject.o Classes/Ozone/renderobject.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexInternalShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexInternalShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexInternalShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexInternalShape.cpp

${OBJECTDIR}/Classes/Ozone/math/Vector.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/math/Vector.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/math
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/math/Vector.o Classes/Ozone/math/Vector.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHinge2Constraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHinge2Constraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHinge2Constraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHinge2Constraint.cpp

${OBJECTDIR}/Classes/Ozone/http/DDData.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/http/DDData.m 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/http
	${RM} $@.d
	$(COMPILE.c) -g -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/http/DDData.o Classes/Ozone/http/DDData.m

${OBJECTDIR}/Classes/Ozone/BossVulcanEnemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/BossVulcanEnemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/BossVulcanEnemy.o Classes/Ozone/BossVulcanEnemy.mm

${OBJECTDIR}/Classes/Ozone/npc.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/npc.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/npc.o Classes/Ozone/npc.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btRaycastCallback.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btRaycastCallback.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btRaycastCallback.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btRaycastCallback.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btSphereShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btSphereShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btSphereShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btSphereShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactShape.o Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactShape.cpp

${OBJECTDIR}/Classes/Ozone/lancesenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/lancesenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/lancesenemy.o Classes/Ozone/lancesenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btSubSimplexConvexCast.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btSubSimplexConvexCast.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btSubSimplexConvexCast.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btSubSimplexConvexCast.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxDetector.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxDetector.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxDetector.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxDetector.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btShapeHull.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btShapeHull.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btShapeHull.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btShapeHull.cpp

${OBJECTDIR}/Classes/Ozone/parsermanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/parsermanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/parsermanager.o Classes/Ozone/parsermanager.mm

${OBJECTDIR}/Classes/Ozone/InGameMenuEndLevel.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/InGameMenuEndLevel.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/InGameMenuEndLevel.o Classes/Ozone/InGameMenuEndLevel.mm

${OBJECTDIR}/Classes/Ozone/http/HTTPConnection.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/http/HTTPConnection.m 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/http
	${RM} $@.d
	$(COMPILE.c) -g -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/http/HTTPConnection.o Classes/Ozone/http/HTTPConnection.m

${OBJECTDIR}/Classes/Ozone/submenumainstate.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/submenumainstate.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/submenumainstate.o Classes/Ozone/submenumainstate.mm

${OBJECTDIR}/Classes/Ozone/particlemanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/particlemanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/particlemanager.o Classes/Ozone/particlemanager.mm

${OBJECTDIR}/Classes/Ozone/SubMenuHelpState.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SubMenuHelpState.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SubMenuHelpState.o Classes/Ozone/SubMenuHelpState.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_memory.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/gim_memory.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_memory.o Classes/Ozone/physics/BulletCollision/Gimpact/gim_memory.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyConcaveCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletSoftBody/btSoftBodyConcaveCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyConcaveCollisionAlgorithm.o Classes/Ozone/physics/BulletSoftBody/btSoftBodyConcaveCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConcaveCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConcaveCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConcaveCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexConcaveCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/menuitem.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/menuitem.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/menuitem.o Classes/Ozone/menuitem.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btEmptyShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btEmptyShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btEmptyShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btEmptyShape.cpp

${OBJECTDIR}/Classes/Ozone/nucleargem.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/nucleargem.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/nucleargem.o Classes/Ozone/nucleargem.mm

${OBJECTDIR}/Classes/Ozone/renderer.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/renderer.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/renderer.o Classes/Ozone/renderer.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkConvexCast.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkConvexCast.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkConvexCast.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkConvexCast.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btOptimizedBvh.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btOptimizedBvh.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btOptimizedBvh.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btOptimizedBvh.cpp

${OBJECTDIR}/Classes/Ozone/conveyorbeltplace.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/conveyorbeltplace.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/conveyorbeltplace.o Classes/Ozone/conveyorbeltplace.mm

${OBJECTDIR}/Classes/Ozone/physicsmanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physicsmanager.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physicsmanager.o Classes/Ozone/physicsmanager.cpp

${OBJECTDIR}/Classes/Ozone/redgem.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/redgem.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/redgem.o Classes/Ozone/redgem.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCollisionShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btCollisionShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCollisionShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btCollisionShape.cpp

${OBJECTDIR}/Classes/Ozone/key.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/key.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/key.o Classes/Ozone/key.mm

${OBJECTDIR}/Classes/Ozone/SubMenuSaveSelectionState.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SubMenuSaveSelectionState.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SubMenuSaveSelectionState.o Classes/Ozone/SubMenuSaveSelectionState.mm

${OBJECTDIR}/Classes/EAGLView.o: nbproject/Makefile-${CND_CONF}.mk Classes/EAGLView.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/EAGLView.o Classes/EAGLView.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereSphereCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereSphereCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereSphereCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereSphereCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btVoronoiSimplexSolver.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btVoronoiSimplexSolver.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btVoronoiSimplexSolver.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btVoronoiSimplexSolver.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btTypedConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btTypedConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btTypedConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btTypedConstraint.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btGeneric6DofConstraint.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyRigidBodyCollisionConfiguration.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletSoftBody/btSoftBodyRigidBodyCollisionConfiguration.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBodyRigidBodyCollisionConfiguration.o Classes/Ozone/physics/BulletSoftBody/btSoftBodyRigidBodyCollisionConfiguration.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultimaterialTriangleMeshShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultimaterialTriangleMeshShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultimaterialTriangleMeshShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btMultimaterialTriangleMeshShape.cpp

${OBJECTDIR}/Classes/Ozone/SubMenuHighScoresState.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SubMenuHighScoresState.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SubMenuHighScoresState.o Classes/Ozone/SubMenuHighScoresState.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btBvhTriangleMeshShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btBvhTriangleMeshShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btBvhTriangleMeshShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btBvhTriangleMeshShape.cpp

${OBJECTDIR}/Classes/Ozone/spittingenemyshotparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/spittingenemyshotparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/spittingenemyshotparticle.o Classes/Ozone/spittingenemyshotparticle.mm

${OBJECTDIR}/Classes/Ozone/electricenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/electricenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/electricenemy.o Classes/Ozone/electricenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btRigidBody.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/Dynamics/btRigidBody.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btRigidBody.o Classes/Ozone/physics/BulletDynamics/Dynamics/btRigidBody.cpp

${OBJECTDIR}/Classes/Ozone/scenetrigger.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/scenetrigger.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/scenetrigger.o Classes/Ozone/scenetrigger.mm

${OBJECTDIR}/Classes/Ozone/math/vfpmath/matrix_impl.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/math/vfpmath/matrix_impl.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/math/vfpmath
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/math/vfpmath/matrix_impl.o Classes/Ozone/math/vfpmath/matrix_impl.cpp

${OBJECTDIR}/Classes/Ozone/searchthrowingenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/searchthrowingenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/searchthrowingenemy.o Classes/Ozone/searchthrowingenemy.mm

${OBJECTDIR}/Classes/Ozone/yellowgem.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/yellowgem.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/yellowgem.o Classes/Ozone/yellowgem.mm

${OBJECTDIR}/Classes/Ozone/triggermanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/triggermanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/triggermanager.o Classes/Ozone/triggermanager.mm

${OBJECTDIR}/Classes/Ozone/SubMenuAwardsState.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SubMenuAwardsState.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SubMenuAwardsState.o Classes/Ozone/SubMenuAwardsState.mm

${OBJECTDIR}/Classes/Ozone/playerredshotparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/playerredshotparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/playerredshotparticle.o Classes/Ozone/playerredshotparticle.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBody.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletSoftBody/btSoftBody.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftBody.o Classes/Ozone/physics/BulletSoftBody/btSoftBody.cpp

${OBJECTDIR}/Classes/Ozone/InGameMenuDie.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/InGameMenuDie.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/InGameMenuDie.o Classes/Ozone/InGameMenuDie.mm

${OBJECTDIR}/Classes/Ozone/texture.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/texture.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/texture.o Classes/Ozone/texture.mm

${OBJECTDIR}/Classes/Ozone/movingwallenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/movingwallenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/movingwallenemy.o Classes/Ozone/movingwallenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btUnionFind.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btUnionFind.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btUnionFind.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btUnionFind.cpp

${OBJECTDIR}/Classes/Ozone/backgrounds.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/backgrounds.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/backgrounds.o Classes/Ozone/backgrounds.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btContactConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btContactConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btContactConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btContactConstraint.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/SphereTriangleDetector.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/SphereTriangleDetector.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/SphereTriangleDetector.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/SphereTriangleDetector.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Vehicle/btWheelInfo.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/Vehicle/btWheelInfo.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Vehicle
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Vehicle/btWheelInfo.o Classes/Ozone/physics/BulletDynamics/Vehicle/btWheelInfo.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleBuffer.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleBuffer.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleBuffer.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleBuffer.cpp

${OBJECTDIR}/Classes/Ozone/textfont.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/textfont.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/textfont.o Classes/Ozone/textfont.mm

${OBJECTDIR}/Classes/Ozone/http/HTTPServer.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/http/HTTPServer.m 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/http
	${RM} $@.d
	$(COMPILE.c) -g -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/http/HTTPServer.o Classes/Ozone/http/HTTPServer.m

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexTriangleMeshShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexTriangleMeshShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexTriangleMeshShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexTriangleMeshShape.cpp

${OBJECTDIR}/Classes/Ozone/mesh.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/mesh.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/mesh.o Classes/Ozone/mesh.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvt.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvt.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvt.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvt.cpp

${OBJECTDIR}/Classes/Ozone/greengem.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/greengem.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/greengem.o Classes/Ozone/greengem.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvtBroadphase.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvtBroadphase.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvtBroadphase.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDbvtBroadphase.cpp

${OBJECTDIR}/Classes/Ozone/particle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/particle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/particle.o Classes/Ozone/particle.mm

${OBJECTDIR}/Classes/Ozone/exitplace.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/exitplace.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/exitplace.o Classes/Ozone/exitplace.mm

${OBJECTDIR}/Classes/Ozone/levelgamestate.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/levelgamestate.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/levelgamestate.o Classes/Ozone/levelgamestate.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btMultiSapBroadphase.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btMultiSapBroadphase.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btMultiSapBroadphase.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btMultiSapBroadphase.cpp

${OBJECTDIR}/Classes/Ozone/electricgem.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/electricgem.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/electricgem.o Classes/Ozone/electricgem.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMinkowskiSumShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btMinkowskiSumShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btMinkowskiSumShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btMinkowskiSumShape.cpp

${OBJECTDIR}/Classes/Ozone/UIManager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/UIManager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/UIManager.o Classes/Ozone/UIManager.mm

${OBJECTDIR}/Classes/Ozone/texturemanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/texturemanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/texturemanager.o Classes/Ozone/texturemanager.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConeShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btConeShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConeShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btConeShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btQuickprof.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/LinearMath/btQuickprof.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/LinearMath
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btQuickprof.o Classes/Ozone/physics/LinearMath/btQuickprof.cpp

${OBJECTDIR}/Classes/Ozone/redkey.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/redkey.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/redkey.o Classes/Ozone/redkey.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHingeConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHingeConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHingeConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btHingeConstraint.cpp

${OBJECTDIR}/Classes/Ozone/spikegroupenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/spikegroupenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/spikegroupenemy.o Classes/Ozone/spikegroupenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btConeTwistConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btConeTwistConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btConeTwistConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btConeTwistConstraint.cpp

${OBJECTDIR}/Classes/Ozone/Result.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/Result.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/Result.o Classes/Ozone/Result.mm

${OBJECTDIR}/Classes/Ozone/bluegem.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/bluegem.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/bluegem.o Classes/Ozone/bluegem.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactQuantizedBvh.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactQuantizedBvh.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactQuantizedBvh.o Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactQuantizedBvh.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexArray.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexArray.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexArray.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexArray.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btPoint2PointConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btPoint2PointConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btPoint2PointConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btPoint2PointConstraint.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDispatcher.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDispatcher.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDispatcher.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btDispatcher.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btHeightfieldTerrainShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btHeightfieldTerrainShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btHeightfieldTerrainShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btHeightfieldTerrainShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btContinuousDynamicsWorld.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/Dynamics/btContinuousDynamicsWorld.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btContinuousDynamicsWorld.o Classes/Ozone/physics/BulletDynamics/Dynamics/btContinuousDynamicsWorld.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btOverlappingPairCache.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btOverlappingPairCache.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btOverlappingPairCache.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btOverlappingPairCache.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btBoxBoxCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactBvh.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactBvh.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactBvh.o Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactBvh.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_contact.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/gim_contact.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_contact.o Classes/Ozone/physics/BulletCollision/Gimpact/gim_contact.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionObject.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionObject.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionObject.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionObject.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btTriangleShapeEx.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/btTriangleShapeEx.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btTriangleShapeEx.o Classes/Ozone/physics/BulletCollision/Gimpact/btTriangleShapeEx.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_tri_collision.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/gim_tri_collision.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_tri_collision.o Classes/Ozone/physics/BulletCollision/Gimpact/gim_tri_collision.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTetrahedronShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btTetrahedronShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTetrahedronShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btTetrahedronShape.cpp

${OBJECTDIR}/Classes/Ozone/math/neonmath/neon_matrix_impl.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/math/neonmath/neon_matrix_impl.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/math/neonmath
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/math/neonmath/neon_matrix_impl.o Classes/Ozone/math/neonmath/neon_matrix_impl.cpp

${OBJECTDIR}/Classes/Ozone/timer.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/timer.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/timer.o Classes/Ozone/timer.mm

${OBJECTDIR}/Classes/Ozone/searchenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/searchenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/searchenemy.o Classes/Ozone/searchenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMesh.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMesh.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMesh.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMesh.cpp

${OBJECTDIR}/Classes/Ozone/inlinethrowingenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/inlinethrowingenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/inlinethrowingenemy.o Classes/Ozone/inlinethrowingenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btStridingMeshInterface.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btStridingMeshInterface.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btStridingMeshInterface.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btStridingMeshInterface.cpp

${OBJECTDIR}/Classes/Ozone/http/HTTPResponse.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/http/HTTPResponse.m 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/http
	${RM} $@.d
	$(COMPILE.c) -g -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/http/HTTPResponse.o Classes/Ozone/http/HTTPResponse.m

${OBJECTDIR}/Classes/Ozone/spikeenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/spikeenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/spikeenemy.o Classes/Ozone/spikeenemy.mm

${OBJECTDIR}/Classes/Ozone/movingcrosssmallenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/movingcrosssmallenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/movingcrosssmallenemy.o Classes/Ozone/movingcrosssmallenemy.mm

${OBJECTDIR}/Classes/Ozone/BossSpaceEnemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/BossSpaceEnemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/BossSpaceEnemy.o Classes/Ozone/BossSpaceEnemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btManifoldResult.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btManifoldResult.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btManifoldResult.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btManifoldResult.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btEmptyCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btEmptyCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btEmptyCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btEmptyCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/submenuepisodeselectionstate.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/submenuepisodeselectionstate.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/submenuepisodeselectionstate.o Classes/Ozone/submenuepisodeselectionstate.mm

${OBJECTDIR}/Classes/Ozone/menugamestate.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/menugamestate.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/menugamestate.o Classes/Ozone/menugamestate.mm

${OBJECTDIR}/Classes/Ozone/teleporterplace.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/teleporterplace.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/teleporterplace.o Classes/Ozone/teleporterplace.mm

${OBJECTDIR}/Classes/Ozone/sound/SoundEngine.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/sound/SoundEngine.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/sound
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/sound/SoundEngine.o Classes/Ozone/sound/SoundEngine.cpp

${OBJECTDIR}/Classes/Ozone/scene.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/scene.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/scene.o Classes/Ozone/scene.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCompoundShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btCompoundShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCompoundShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btCompoundShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_box_set.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/gim_box_set.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/gim_box_set.o Classes/Ozone/physics/BulletCollision/Gimpact/gim_box_set.cpp

${OBJECTDIR}/Classes/Ozone/startplace.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/startplace.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/startplace.o Classes/Ozone/startplace.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpa2.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpa2.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpa2.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpa2.cpp

${OBJECTDIR}/Classes/Ozone/ScoresView.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/ScoresView.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/ScoresView.o Classes/Ozone/ScoresView.mm

${OBJECTDIR}/Classes/Ozone/itemparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/itemparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/itemparticle.o Classes/Ozone/itemparticle.mm

${OBJECTDIR}/Classes/Ozone/introgamestate.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/introgamestate.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/introgamestate.o Classes/Ozone/introgamestate.mm

${OBJECTDIR}/Classes/Ozone/sector.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/sector.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/sector.o Classes/Ozone/sector.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMeshShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMeshShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMeshShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleMeshShape.cpp

${OBJECTDIR}/Classes/Ozone/npcfactory.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/npcfactory.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/npcfactory.o Classes/Ozone/npcfactory.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSolve2LinearConstraint.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSolve2LinearConstraint.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSolve2LinearConstraint.o Classes/Ozone/physics/BulletDynamics/ConstraintSolver/btSolve2LinearConstraint.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Vehicle/btRaycastVehicle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/Vehicle/btRaycastVehicle.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Vehicle
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Vehicle/btRaycastVehicle.o Classes/Ozone/physics/BulletDynamics/Vehicle/btRaycastVehicle.cpp

${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btAlignedAllocator.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/LinearMath/btAlignedAllocator.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/LinearMath
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/LinearMath/btAlignedAllocator.o Classes/Ozone/physics/LinearMath/btAlignedAllocator.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btBoxShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btBoxShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btBoxShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btBoxShape.cpp

${OBJECTDIR}/Classes/Ozone/episode.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/episode.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/episode.o Classes/Ozone/episode.mm

${OBJECTDIR}/Classes/Ozone/BossEarthEnemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/BossEarthEnemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/BossEarthEnemy.o Classes/Ozone/BossEarthEnemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btStaticPlaneShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btStaticPlaneShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btStaticPlaneShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btStaticPlaneShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCompoundCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCompoundCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCompoundCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCompoundCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/meshmanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/meshmanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/meshmanager.o Classes/Ozone/meshmanager.mm

${OBJECTDIR}/Classes/Ozone/bladeenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/bladeenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/bladeenemy.o Classes/Ozone/bladeenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexHullShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexHullShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexHullShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexHullShape.cpp

${OBJECTDIR}/Classes/Ozone/InGameMenuMain.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/InGameMenuMain.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/InGameMenuMain.o Classes/Ozone/InGameMenuMain.mm

${OBJECTDIR}/Classes/Ozone/ScoreController.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/ScoreController.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/ScoreController.o Classes/Ozone/ScoreController.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btQuantizedBvh.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btQuantizedBvh.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btQuantizedBvh.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btQuantizedBvh.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btContactProcessing.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/btContactProcessing.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btContactProcessing.o Classes/Ozone/physics/BulletCollision/Gimpact/btContactProcessing.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftSoftCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletSoftBody/btSoftSoftCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftSoftCollisionAlgorithm.o Classes/Ozone/physics/BulletSoftBody/btSoftSoftCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/math/Matrix.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/math/Matrix.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/math
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/math/Matrix.o Classes/Ozone/math/Matrix.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexPlaneCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexPlaneCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexPlaneCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btConvexPlaneCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/BossSpaceShotParticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/BossSpaceShotParticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/BossSpaceShotParticle.o Classes/Ozone/BossSpaceShotParticle.mm

${OBJECTDIR}/Classes/Ozone/inputmanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/inputmanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/inputmanager.o Classes/Ozone/inputmanager.mm

${OBJECTDIR}/Classes/Ozone/gamemanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/gamemanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/gamemanager.o Classes/Ozone/gamemanager.mm

${OBJECTDIR}/Classes/Ozone/camera.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/camera.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/camera.o Classes/Ozone/camera.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCapsuleShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btCapsuleShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btCapsuleShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btCapsuleShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexPointCloudShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexPointCloudShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexPointCloudShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btConvexPointCloudShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btBroadphaseProxy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btBroadphaseProxy.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btBroadphaseProxy.o Classes/Ozone/physics/BulletCollision/BroadphaseCollision/btBroadphaseProxy.cpp

${OBJECTDIR}/Classes/Ozone/inlinethrowingenemyshotparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/inlinethrowingenemyshotparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/inlinethrowingenemyshotparticle.o Classes/Ozone/inlinethrowingenemyshotparticle.mm

${OBJECTDIR}/Classes/Ozone/SubMenuCreditsState.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SubMenuCreditsState.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SubMenuCreditsState.o Classes/Ozone/SubMenuCreditsState.mm

${OBJECTDIR}/Classes/Ozone/http/DDNumber.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/http/DDNumber.m 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/http
	${RM} $@.d
	$(COMPILE.c) -g -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/http/DDNumber.o Classes/Ozone/http/DDNumber.m

${OBJECTDIR}/Classes/Ozone/searchthrowingenemyshotparticle.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/searchthrowingenemyshotparticle.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/searchthrowingenemyshotparticle.o Classes/Ozone/searchthrowingenemyshotparticle.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btScaledBvhTriangleMeshShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btScaledBvhTriangleMeshShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btScaledBvhTriangleMeshShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btScaledBvhTriangleMeshShape.cpp

${OBJECTDIR}/Classes/Ozone/movingcrossenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/movingcrossenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/movingcrossenemy.o Classes/Ozone/movingcrossenemy.mm

${OBJECTDIR}/Classes/Ozone/hud.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/hud.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/hud.o Classes/Ozone/hud.mm

${OBJECTDIR}/Classes/Ozone/armenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/armenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/armenemy.o Classes/Ozone/armenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btSimpleDynamicsWorld.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletDynamics/Dynamics/btSimpleDynamicsWorld.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletDynamics/Dynamics/btSimpleDynamicsWorld.o Classes/Ozone/physics/BulletDynamics/Dynamics/btSimpleDynamicsWorld.cpp

${OBJECTDIR}/Classes/Ozone/player.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/player.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/player.o Classes/Ozone/player.mm

${OBJECTDIR}/Classes/Ozone/interpolatormanager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/interpolatormanager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/interpolatormanager.o Classes/Ozone/interpolatormanager.mm

${OBJECTDIR}/Classes/Ozone/math/vfpmath/utility_impl.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/math/vfpmath/utility_impl.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/math/vfpmath
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/math/vfpmath/utility_impl.o Classes/Ozone/math/vfpmath/utility_impl.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btPolyhedralConvexShape.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btPolyhedralConvexShape.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btPolyhedralConvexShape.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btPolyhedralConvexShape.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpaPenetrationDepthSolver.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpaPenetrationDepthSolver.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpaPenetrationDepthSolver.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkEpaPenetrationDepthSolver.cpp

${OBJECTDIR}/Classes/Ozone/http/AsyncSocket.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/http/AsyncSocket.m 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/http
	${RM} $@.d
	$(COMPILE.c) -g -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/http/AsyncSocket.o Classes/Ozone/http/AsyncSocket.m

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/Gimpact/btGImpactCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/InGameMenu.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/InGameMenu.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/InGameMenu.o Classes/Ozone/InGameMenu.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereBoxCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereBoxCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereBoxCollisionAlgorithm.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btSphereBoxCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/HelpButton.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/HelpButton.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/HelpButton.o Classes/Ozone/HelpButton.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexMaterialArray.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexMaterialArray.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexMaterialArray.o Classes/Ozone/physics/BulletCollision/CollisionShapes/btTriangleIndexVertexMaterialArray.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionWorld.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionWorld.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionWorld.o Classes/Ozone/physics/BulletCollision/CollisionDispatch/btCollisionWorld.cpp

${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftRigidDynamicsWorld.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletSoftBody/btSoftRigidDynamicsWorld.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftRigidDynamicsWorld.o Classes/Ozone/physics/BulletSoftBody/btSoftRigidDynamicsWorld.cpp

${OBJECTDIR}/Classes/Ozone/SubMenuOptionsState.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SubMenuOptionsState.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SubMenuOptionsState.o Classes/Ozone/SubMenuOptionsState.mm

${OBJECTDIR}/Classes/Ozone/http/DDRange.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/http/DDRange.m 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/http
	${RM} $@.d
	$(COMPILE.c) -g -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/http/DDRange.o Classes/Ozone/http/DDRange.m

${OBJECTDIR}/Classes/Ozone/multibladeenemy.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/multibladeenemy.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/multibladeenemy.o Classes/Ozone/multibladeenemy.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkPairDetector.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkPairDetector.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkPairDetector.o Classes/Ozone/physics/BulletCollision/NarrowPhaseCollision/btGjkPairDetector.cpp

${OBJECTDIR}/Classes/Ozone/SaveManager.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/SaveManager.mm 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/SaveManager.o Classes/Ozone/SaveManager.mm

${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftRigidCollisionAlgorithm.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physics/BulletSoftBody/btSoftRigidCollisionAlgorithm.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physics/BulletSoftBody/btSoftRigidCollisionAlgorithm.o Classes/Ozone/physics/BulletSoftBody/btSoftRigidCollisionAlgorithm.cpp

${OBJECTDIR}/Classes/Ozone/physicsdebugdrawer.o: nbproject/Makefile-${CND_CONF}.mk Classes/Ozone/physicsdebugdrawer.cpp 
	${MKDIR} -p ${OBJECTDIR}/Classes/Ozone
	${RM} $@.d
	$(COMPILE.cc) -g -IClasses/Ozone/physics -I../Frameworks/CoreGraphics.framework/Headers -I../Frameworks/AudioToolbox.framework/Headers -I../Frameworks/AVFoundation.framework/Headers -I../Frameworks/CoreAudio.framework/Headers -I../Frameworks/Foundation.framework/Headers -I../Frameworks/OpenAL.framework/Headers -I../Frameworks/QuartzCore.framework/Headers -I../Frameworks/UIKit.framework/Headers -I../Frameworks/OpenGLES.framework/Headers -IClasses/Ozone/sound -IClasses/Ozone/math -MMD -MP -MF $@.d -o ${OBJECTDIR}/Classes/Ozone/physicsdebugdrawer.o Classes/Ozone/physicsdebugdrawer.cpp

# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/Debug
	${RM} dist/Debug/GNU-Linux-x86/ozone

# Subprojects
.clean-subprojects:

# Enable dependency checking
.dep.inc: .depcheck-impl

include .dep.inc
