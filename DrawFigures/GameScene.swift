//
//  GameScene.swift
//  DrawFigures
//
//  Created by Albert Barrientos on 06-02-17.
//  Copyright © 2017 Miaum. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene
{
    var positions = [[Int]]()
    var actualArray = 0;
    
    var rawPoints:[Int] = []

    var label:SKLabelNode!
    var nodeBg:SKSpriteNode!
    var drawSpace: SKSpriteNode!
    
    var btnPos  : SKSpriteNode!
    var btnReset: SKSpriteNode!
    var btnAddLine: SKSpriteNode!
    
    override func didMove(to view: SKView)
    {
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        self.label.alpha = 0
        
        nodeBg = SKSpriteNode(
            color: UIColor(red: 1, green: 1, blue: 0, alpha: 0.3),
            size: CGSize(
                width: self.frame.width,
                height: self.frame.height*0.9
            )
        )
        print(" w: \(self.frame.width) h: \(self.frame.height*0.9)")
        nodeBg.zPosition = 100
        self.addChild(nodeBg)
        
        drawSpace = SKSpriteNode(
            color: UIColor.white,
            size: CGSize(
                width: self.frame.width,
                height: self.frame.height*0.9
            )
        )
        drawSpace.zPosition = 90
        self.addChild(drawSpace)
        
        
        btnPos = SKSpriteNode(
            color: UIColor.blue,
            size: CGSize(
                width: self.frame.width*0.3,
                height: self.frame.height*0.07
            )
        )
        
        btnPos.position = CGPoint(
            x: -self.frame.width*0.5 + btnPos.frame.width*0.5 + 10,
            y: -self.frame.height*0.5 + btnPos.frame.height + 10
        )

        btnPos.zPosition = 200
        btnPos.addChild(SKLabelNode(text: "Posiones"))
        self.addChild(btnPos)
        
        
        btnReset = SKSpriteNode(
            color: UIColor.red,
            size: CGSize(
                width: self.frame.width*0.3,
                height: self.frame.height*0.07
            )
        )
        btnReset.position = CGPoint(
            x: self.frame.width*0.5 - btnReset.frame.width*0.5 - 10,
            y: -self.frame.height*0.5 + btnReset.frame.height + 10
        )

        btnReset.zPosition = 200
        btnReset.addChild(SKLabelNode(text: "Reset"))
        self.addChild(btnReset)
        
        btnAddLine = SKSpriteNode(
            color: UIColor.purple,
            size: CGSize(
                width: self.frame.width*0.3,
                height: self.frame.height*0.07
            )
        )
        btnAddLine.position = CGPoint(
            x: 0,
            y: -self.frame.height*0.5 + btnAddLine.frame.height + 10
        )
        
        btnAddLine.zPosition = 200
        btnAddLine.addChild(SKLabelNode(text: "Add Line"))
        self.addChild(btnAddLine)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        let location = touch!.location(in: self)
        let node = self.atPoint(location)
        
        if node == nodeBg
        {
            rawPoints = []
            
            let touch = touches.first
            let location = touch!.location(in: self)
            
            rawPoints.append(Int(location.x))
            rawPoints.append(Int(location.y))
        }
        
        if node == btnPos
        {
            printPoints()
        }
        
        if node == btnAddLine
        {
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        let location = touch!.location(in: self)
        let node = self.atPoint(location)
        
        if node == nodeBg
        {
            if(rawPoints[rawPoints.count-2] != Int(location.x) && rawPoints[rawPoints.count-1] != Int(location.y))
            {
                rawPoints.append(Int(location.x))
                rawPoints.append(Int(location.y))
            }
            draw()
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        let location = touch!.location(in: self)
        let node = self.atPoint(location)
        
        if node == nodeBg
        {
            if rawPoints.count > 0
            {
                positions.append(rawPoints)
            }
        }
        
        if node == btnReset
        {
            resetAll()
        }
    }

    
    func printPoints()
    {
        var allPisitions = [[Int]]()
        for position in positions
        {
            var newPoints = [Int:[Int]]()
            
            for i in 0 ..< position.count
            {
                if i % 2 == 0
                {
                    let distance = getDistance(position:position, currentPosition:i)
                    if distance > 10
                    {
                        let slope = getSlope(position:position, currentPosition:i)

                        let π = CGFloat(M_PI)
                        let ø = atan(slope)*180/π
                        
                        let pointAdds = getPoints(slope: slope, distance:distance, angle: ø, position: position, currentPosition: i)

                        newPoints[i+2] = pointAdds
                        //newPoints.append((pos:i+2,array:pointAdds))
                    }
                }
            }
            print(" ----------- ")
            print("count: \(newPoints.count)")
            print(" \(newPoints)")
            print(" ----------- ")
            
            var newPos = [Int]()
            for i in 0 ..< position.count
            {
                if newPoints[i] != nil
                {
                    print("i: \(i) \(newPoints[i])")
                    var imprime = [Int]()
                    for point in newPoints[i]!
                    {
                        imprime.append(point)
                        newPos.append(point)
                    }
                    print("i: i imprime: \(imprime)")
                    print("")
                }
                
                newPos.append(position[i])
            }
            print("-----  NEW POS -----")
            print(newPos)
            allPisitions.append(newPos)
        }
        print("-----  ALL POS -----")
        print(allPisitions)
    }
    
    func getPoints(slope:CGFloat, distance: CGFloat, angle:CGFloat, position:[Int], currentPosition:Int) -> [Int]
    {
        var positions = [Int]()
        
        let Ax = position[currentPosition]
        let Ay = position[currentPosition+1]
        
        let Bx = position[currentPosition+2]
        let By = position[currentPosition+3]
        
        let step:CGFloat = 5
        
        let n = Int(distance/step)
        
        print("Ax: \(Ax) Ay: \(Ay)")
        for i in 1 ..< n+1
        {
            let dx = abs(CGFloat(i)*step*cos(angle * CGFloat(M_PI) / 180.0))
            let dy = abs(CGFloat(i)*step*sin(angle * CGFloat(M_PI) / 180.0))
            
            let x = Ax < Bx ? Ax + Int(dx) : Ax - Int(dx)
            let y = Ay < By ? Ay + Int(dy) : Ay - Int(dy)
            
            print("x: \(x)  y: \(y)     ----    dx \(dx) dy \(dy)")
            
            positions.append(Int(x))
            positions.append(Int(y))

        }
        print("Bx: \(Bx) By: \(By)")
        
        return positions
        
    }
    
    func getDistance(position:[Int], currentPosition:Int) -> CGFloat
    {
        let Ax = position[currentPosition]
        let Ay = position[currentPosition+1]
        
        let j = currentPosition + 2
        if position.count > j
        {
            
            let a = CGPoint(
                x: Ax,
                y: Ay
            )
            
            let Bx = position[j]
            let By = position[j+1]
            
            let b = CGPoint(
                x: Bx,
                y:By
            )
            
            return getDistance(a:a, b:b)

        }
        
        return 0
    }
    
    private func getDistance(a:CGPoint, b:CGPoint) -> CGFloat
    {
        let A = (a.x-b.x)*(a.x-b.x)
        let B = (a.y-b.y)*(a.y-b.y)
        let d = sqrt( Double(A + B) )
        return CGFloat(d)
    }
    
    func getSlope(position:[Int], currentPosition:Int) -> CGFloat
    {
        let Ax = position[currentPosition]
        let Ay = position[currentPosition+1]
        
        let j = currentPosition + 2
        if position.count > j
        {
            let a = CGPoint(
                x: Ax,
                y: Ay
            )
            
            let Bx = position[j]
            let By = position[j+1]
            
            let b = CGPoint(
                x: Bx,
                y:By
            )
            return getSlope(a: a, b: b)

        }
        
        return 0
    }
    private func getSlope(a:CGPoint, b:CGPoint) -> CGFloat
    {
        let dX = CGFloat(a.x-b.x)
        let dY = CGFloat(a.y-b.y)
        return dY/dX
    }
    
    
    func draw()
    {
        let context = UIBezierPath()
        if rawPoints.count > 4
        {
            
            context.move(to: CGPoint(x: CGFloat(rawPoints[0]), y: CGFloat(rawPoints[1])))
            
            for i in 2..<rawPoints.count
            {
                if i % 2 == 0 {
                    context.addLine(to: CGPoint(x: CGFloat(rawPoints[i]), y: CGFloat(rawPoints[i + 1])))
                }
            }
        }
        
        let line = SKShapeNode()
        line.lineWidth = 10
        line.strokeColor = UIColor.blue
        drawSpace.addChild(line)
        line.path = context.cgPath
        
    }
    
    func resetAll()
    {
        drawSpace.removeAllChildren()
        positions = [[Int]]()
    }
}
