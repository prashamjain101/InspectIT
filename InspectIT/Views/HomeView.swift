//
//  HomeView.swift
//  InspectIT
//
//  Created by Prasham Jain on 24/06/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var reachability: Reachability
    
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.showNetworkStatus {
                    VStack {
                        Text(reachability.isConnected ? "Online" : "Offline")
                            .frame(width: screenSize.width)
                            .padding()
                            .background(reachability.isConnected ? Color.green : Color.red)
                            .foregroundColor(.white)
                    }
                    .scaleEffect(viewModel.showNetworkStatus ? 1 : 0, anchor: .top)
                    .opacity(viewModel.showNetworkStatus ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.showNetworkStatus)
                }
                
                VStack {
                    Text("Welcome")
                        .font(.title2)
                    
                    Picker("Inspection", selection: $viewModel.selectedSegment) {
                        Text("Drafts").tag(0)
                        Text("Completed").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onChange(of: viewModel.selectedSegment) { newValue in
                        let status: InspectionStatus = (newValue == 0) ? .draft : .completed
                        viewModel.fetchInspectionResponses(for: status)
                    }
                    
                    if viewModel.inspectionResponses.isEmpty {
                        Text(viewModel.selectedSegment == 0 ? "No Draft Inspections. Click on Add button to create one." : "No Completed Inspections")
                            .padding()
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            VStack {
                                ForEach(viewModel.inspectionResponses) { response in
                                    InspectionRowView(response: response)
                                        .onTapGesture {
                                            viewModel.selectedResponse = response
                                            viewModel.showInspectionView = true
                                        }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top, 45)
            .onReceive(reachability.$isConnected) { _ in
                showNetworkStatusTemporarily()
            }
            
            Button(action: {
                viewModel.selectedResponse = nil
                viewModel.showInspectionView = true
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .position(x: screenSize.width - 60, y: screenSize.height - 60)
            .padding()
            .fullScreenCover(isPresented: $viewModel.showInspectionView) {
                InspectionView(delegate: viewModel, response: viewModel.selectedResponse)
            }
        }
        .onAppear(perform: {
            viewModel.fetchInspectionResponses(for: viewModel.selectedSegment == 0 ? .draft : .completed)
        })
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func showNetworkStatusTemporarily() {
        withAnimation {
            viewModel.showNetworkStatus = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                viewModel.showNetworkStatus = false
            }
        }
    }
}

struct InspectionRowView: View {
    let response: InspectionResponse
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Inspection ID: #\(response.inspection.id)")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Area: \(response.inspection.area?.name ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Text(summaryText)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Type: \(response.inspection.inspectionType?.name ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                    }.padding(.top)
                }
            }
            .padding()
            .background(response.inspection.inspectionStatus == .completed ? Color.green : Color.orange)
            .cornerRadius(10)
            .shadow(radius: 5)
            
            if isExpanded, let categories = response.inspection.survey?.categories {
                ForEach(categories, id: \.id) { category in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(category.name)
                            .font(.headline)
                            .foregroundColor(.blue)
                        ForEach(category.questions ?? [], id: \.id) { question in
                            HStack {
                                Text(question.name)
                                    .font(.subheadline)
                                Spacer()
                                Text(question.selectedAnswerChoiceId != nil ? "Answered" : "Unanswered")
                                    .font(.subheadline)
                                    .foregroundColor(question.selectedAnswerChoiceId != nil ? .green : .red)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private var summaryText: String {
        guard let categories = response.inspection.survey?.categories else {
            return "No questions available"
        }
        let totalQuestions = categories.reduce(0) { $0 + ($1.questions?.count ?? 0) }
        let answeredQuestions = categories.reduce(0) { $0 + ($1.questions?.filter { $0.selectedAnswerChoiceId != nil }.count ?? 0) }
        let percentageLeft = Double(totalQuestions - answeredQuestions) / Double(totalQuestions) * 100
        
        return "\(answeredQuestions)/\(totalQuestions) Questions (\(Int(percentageLeft))% left)"
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Reachability())
    }
}

